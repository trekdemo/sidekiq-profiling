module Sidekiq
  module Profiling

    class Middleware
      include Sidekiq::Util
      @@last_sample   = -1
      @@instance_lock = Mutex.new

      attr_accessor :sample_interval, :use_gc, :samples_kept

      def initialize(options = {})
        @sample_interval = options.fetch(:sample_interval) { 3 }
        @use_gc          = options.fetch(:use_gc)          { true }
        @samples_kept    = options.fetch(:samples_kept)    { 500 }
      end

      def call(worker, msg, queue, &blk)
        if need_sample?
          sample_worker(worker, &blk)
        else
          yield
        end
      end

      private
      def need_sample?
        @@instance_lock.synchronize do
          timestamp = Time.now.to_i
          delta     = timestamp - sample_interval
          if @need_sample = @@last_sample < delta
            @@last_sample = timestamp
          end
        end

        @need_sample
      end

      def sample_worker(worker, &blk)
        GC.start if use_gc
        yield
      ensure
        save_perf_data(worker)
      end

      def save_perf_data(worker)
        data             = ObjectSpace.count_objects
        data[:worker]    = worker.class.name
        data[:timestamp] = @@last_sample

        Sidekiq.redis do |conn|
          conn.lpush(:allocation_profiling, Sidekiq.dump_json(data))
          conn.ltrim(:allocation_profiling, 0, samples_kept - 1)
        end
        Sidekiq.logger.info "[AllocationProfiler] #{data}"
      end

    end
  end
end
