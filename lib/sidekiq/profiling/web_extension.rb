module Sidekiq
  module Profiling
    module WebExtension

      def self.registered(app)
        app.get '/profiling' do
          view_path = File.join(File.expand_path('..', __FILE__), 'views')

          @count = (params[:count] || 25).to_i
          (@current_page, @total_size, @messages) = page("allocation_profiling", params[:page], @count)
          @messages = @messages.map { |msg| Sidekiq.load_json(msg) }
          @types = @messages.first.keys

          render(:erb, File.read(File.join(view_path, "profiling.erb")))
        end
      end
    end
  end
end
