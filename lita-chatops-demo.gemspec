Gem::Specification.new do |spec|
  spec.name          = 'lita-chatops-demo'
  spec.version       = '0.1.0'
  spec.authors       = ['Infralovers']
  spec.email         = ['team@infralovers.com']
  spec.description   = 'A Lita Handler for custom deployments'
  spec.summary       = 'get input via chat and trigger jenkins jobs'
  spec.homepage      = 'https://github.com/infralovers/lita-chatops-demo'
  spec.license       = 'TODO: Add a license'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.7'
  spec.add_runtime_dependency 'jenkins_api_client', '~> 1.4.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'lita-slack', '~> 1.6'
  spec.add_development_dependency 'mock_redis', '~> 0.15.3'
end
