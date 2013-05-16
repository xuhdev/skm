# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)
require File.expand_path('../lib/skm/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'skm'
  s.authors       = [ 'Hong Xu' ]
  s.email         = 'hong@topbug.net'
  s.version       = SshKeyManager::VERSION::STRING.dup
  s.homepage      = 'https://github.com/xuhdev/skm#readme'
  s.summary       = 'Manage Multiple ssh keys'
  s.description   = ''
  s.files         = Dir['{bin,lib}/**/*', 'LICENSE', 'README*']
  s.executables << 'skm'
  s.license       = 'BSD'

  s.add_dependency 'trollop', '~> 2.0'
  s.add_development_dependency 'rake', '~> 10.0.4'
  s.add_development_dependency 'rspec', '~> 2.13.0'
end
