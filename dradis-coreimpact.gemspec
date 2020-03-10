$:.push File.expand_path('../lib', __FILE__)
require 'dradis/plugins/coreimpact/version'
version = Dradis::Plugins::Coreimpact::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'dradis-coreimpact'
  spec.version     = version
  spec.summary     = 'CORE Impact add-on for the Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse output produced from CORE Impact security scanner into Dradis.'

  spec.license     = 'GPL-2'

  spec.authors     = ['Daniel Martin']
  spec.email       = ['etd@nomejortu.com']
  spec.homepage    = 'http://dradisframework.org'

  spec.files       = `git ls-files`.split($\)
  spec.executables = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files  = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_dependency 'dradis-plugins', '~> 3.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '~> 0.5.2'
end
