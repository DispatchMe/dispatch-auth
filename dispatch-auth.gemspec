# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'dispatch/auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'dispatch-auth'
  spec.version       = Dispatch::Auth::VERSION
  spec.authors       = ['rilian']
  spec.email         = ['dmitriyis@gmail.com', 'creeonix@gmail.com']
  spec.summary       = 'Gem to authenticate requests for Dispatch APIs'
  spec.description   = 'Gem to authenticate requests for Dispatch APIs, by passing Authorization token to Dispatch Users API'
  spec.homepage      = 'http://dispatch.me'
  spec.license       = 'MIT'

  #spec.files         = `git ls-files -z`.split("\x0")
  spec.files         = Dir.glob('{lib}/**/*') + %w(README.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '>= 0.13.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
