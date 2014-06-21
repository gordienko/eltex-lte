# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eltex/lte/version'
require 'eltex/lte/session'

Gem::Specification.new do |spec|
  spec.name          = "eltex-lte"
  spec.version       = Eltex::Lte::VERSION
  spec.authors       = ["Alexey Gordienko"]
  spec.email         = ["alx@anadyr.org"]
  spec.summary       = %q{Ruby gem for management Eltex LTE via SSH}
  spec.description   = %q{This gem aims to provide transport-flexible functionality, for easy communication with Eltex LTE devices}
  spec.homepage      = "http://github.com/gordienko/eltex-lte"
  spec.license       = "MIT"

  spec.files = [
     ".gitignore",
     "LICENSE.txt",
     "README.md",
     "Rakefile",
     "eltex-lte.gemspec",
     "lib/eltex/lte.rb",
     "lib/eltex/lte/version.rb",
     "lib/eltex/lte/session.rb"
    ]

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
