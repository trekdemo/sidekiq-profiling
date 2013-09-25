module Sidekiq
  module Profiling

    class Middleware
      include Sidekiq::Util
      attr_accessor :msg

      def call(worker, msg, queue)
        yield
        data = ObjectSpace.count_objects

        Sidekiq.redis do |conn|
          conn.lpush(:allocation_profiling, Sidekiq.dump_json(data))
          conn.ltrim(:allocation_profiling, 0, 300 - 1)
        end

        raise e
      end

    end
  end
end
