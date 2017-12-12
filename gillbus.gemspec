
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gillbus/version'

Gem::Specification.new do |spec|
  spec.name          = 'gillbus'
  spec.version       = Gillbus::VERSION
  spec.authors       = ['Alexey "codesnik" Trofimenko', 'Kirill Platonov']
  spec.email         = ['aronaxis@gmail.com', 'mail@kirillplatonov.com']
  spec.summary       = 'Driver for Gillbus IDS API'
  # spec.description   = %q{gillbus.com}
  spec.homepage      = 'http://gillbus.com/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'
  spec.add_dependency 'monetize'
  spec.add_dependency 'money'
  spec.add_dependency 'multi_xml'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
end
