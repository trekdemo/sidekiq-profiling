# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sidekiq/profiling/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gergo sulymosi"]
  gem.email         = ["gergo.sulymosi@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/trekdemo/sidekiq-profiling/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sidekiq-profiling"
  gem.require_paths = ["lib"]
  gem.version       = Sidekiq::Profiling::VERSION

  gem.add_dependency "sidekiq", ">= 2.9.0"
  gem.add_dependency "chartkick", '>= 1.1.1'
  gem.add_dependency "sinatra-assetpack", '>= 0.2.5'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "sprockets"
  gem.add_development_dependency "sinatra"
end
