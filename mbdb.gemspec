# coding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mbdb/version'

Gem::Specification.new do |spec|
	spec.name          = 'mbdb'
	spec.version       = TheFox::MBDB::VERSION
	spec.date          = TheFox::MBDB::DATE
	spec.author        = 'Christian Mayer'
	spec.email         = 'christian@fox21.at'
	
	spec.summary       = %q{Extended Ruby Classes}
	spec.description   = %q{This gem extents some of the basic Ruby classes by missing functionalities.}
	spec.homepage      = TheFox::MBDB::HOMEPAGE
	spec.license       = 'GPL-3.0'
	
	spec.files         = `git ls-files -z`.split("\x0").reject{ |f| f.match(%r{^(test|spec|features)/}) }
	spec.require_paths = ['lib']
	spec.required_ruby_version = '>=2.1.0'
	
	spec.add_development_dependency 'pry', '~>0.10'
	
	spec.add_development_dependency 'minitest', '~>5.9'
	spec.add_development_dependency 'simplecov', '~>0.12'
	spec.add_development_dependency 'simplecov-phpunit', '~>1.0'
end
