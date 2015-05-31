# -*- encoding: utf-8 -*-
require File.expand_path('../lib/whos_got_dirt/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "whos_got_dirt"
  s.version     = WhosGotDirt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James McKinney"]
  s.homepage    = "https://github.com/influencemapping/whos_got_dirt"
  s.summary     = %q{A federated search API for people and organizations}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('activesupport', '~> 4.2.0')

  s.add_development_dependency('coveralls')
  s.add_development_dependency('faraday')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.1')
end
