begin
  require "sidekiq/web"
rescue LoadError
  # client-only usage
end

require "sidekiq/profiling/version"
require "sidekiq/profiling/middleware"
require "sidekiq/profiling/web_extension"

module Sidekiq
  module Profiling
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Profiling::Middleware
  end
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::Profiling::WebExtension

  if Sidekiq::Web.tabs.is_a?(Array)
    # For sidekiq < 2.5
    Sidekiq::Web.tabs << "profiling"
  else
    Sidekiq::Web.tabs["Profiling"] = "profiling"
  end
end
