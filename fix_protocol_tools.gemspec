# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fix_protocol_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "fix_protocol_tools"
  spec.version       = FixProtocolTools::VERSION
  spec.authors       = ["Luxor"]
  spec.email         = ["atuzov@gmail.com"]
  spec.description   = %q{log viewer for fix protocol logs}
  spec.summary       = %q{Works like gzless, you just read fix file in human readable format}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.add_dependency 'term-ansicolor', '>= 1.1.5'

  spec.rubygems_version = '>= 1.6.1'
  spec.files         = `git ls-files`.split($/).grep(%r{^(lib|bin)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
