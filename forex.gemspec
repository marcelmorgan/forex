# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forex/version'

Gem::Specification.new do |spec|
  spec.name          = "forex"
  spec.version       = Forex::VERSION
  spec.authors       = ["Marcel Morgan"]
  spec.email         = ["marcel.morgan@codedry.com"]
  spec.description   = %q{Forex Rates for traders using a simple DSL for parsing}
  spec.summary       = %q{Forex Rates for traders}
  spec.homepage      = "https://github.com/mcmorgan/forex"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "json"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
