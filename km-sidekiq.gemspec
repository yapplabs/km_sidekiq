# -*- encoding: utf-8 -*-
require File.expand_path('../lib/km_sidekiq/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Luke Melia"]
  gem.email         = ["luke@lukemelia.com"]
  gem.description   = %q{Interact with the KISSMetrics API via Sidekiq}
  gem.summary       = %q{Interact with the KISSMetrics API via Sidekiq}
  gem.homepage      = "https://github.com/yapplabs/km_sidekiq"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "km_sidekiq"
  gem.require_paths = ["lib"]
  gem.version       = KmSidekiq::VERSION

  gem.add_dependency 'sidekiq', '>= 2.0.0'
  gem.add_development_dependency 'rspec-sidekiq'
  gem.add_development_dependency 'webmock'
end
