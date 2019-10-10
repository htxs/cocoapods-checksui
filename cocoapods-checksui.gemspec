# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods_check_sui.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-checksui'
  spec.version       = CocoapodsCheckSui::VERSION
  spec.authors       = ['htxs']
  spec.email         = ['gzucm_tianjie@foxmail.com']

  spec.summary       = %q{'checksui' plugin for CocoaPods}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/htxs/cocoapods-checksui"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency "rake", '~> 10.0'
  spec.add_development_dependency "rspec"

  spec.add_dependency 'cocoapods', '~> 1.0'
end
