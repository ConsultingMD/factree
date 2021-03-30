# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factree/version'

Gem::Specification.new do |spec|
  spec.name          = "factree"
  spec.version       = Factree::VERSION
  spec.authors       = ["Josh Strater"]
  spec.email         = ["josh.strater@grandrounds.com"]

  spec.summary       = %q{Decision trees that request facts as needed}
  spec.homepage      = "https://github.com/ConsultingMD/factree"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "yard", "~> 0.9"
end
