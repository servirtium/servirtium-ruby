# frozen_string_literal: true

require_relative 'lib/servirtium/version'

Gem::Specification.new do |spec|
  spec.name = 'servirtium'
  spec.version = Servirtium::VERSION
  spec.authors = ['Rob Park']
  spec.email = ['robert.park@4legssoftware.com']

  spec.summary = 'Service Virtualization standard using markdown for record/playback'
  spec.description = <<~DESCRIPTION
    A Ruby port for a Service Virtualization standard using markdown for record/playback.
  DESCRIPTION
  spec.homepage = 'https://github.com/servirtium/servirtium-ruby'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir['lib/**/*']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'gyoku'
end
