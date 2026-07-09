# frozen_string_literal: true

SDK_PATH = "kinde_api"

$LOAD_PATH.push File.expand_path("lib", __dir__)
$LOAD_PATH.push File.expand_path("app", __dir__)
$LOAD_PATH.push File.expand_path("config", __dir__)
$LOAD_PATH.push File.expand_path("#{SDK_PATH}/lib", __dir__)

require "kinde_sdk/version"

Gem::Specification.new do |s|
  s.name        = "kinde_sdk"
  s.version     = KindeSdk::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kinde Australia Pty Ltd"]
  s.email       = ["support@kinde.com"]
  s.homepage    = "https://kinde.com/"
  s.summary     = "Kinde Management API Ruby Gem"
  s.description = "Integrate the Kinde API into any ruby-based applications, Rails or non-Rails"
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.0"

  s.add_runtime_dependency "typhoeus", "~> 1.0", ">= 1.0.1"
  s.add_runtime_dependency "oauth2", "~> 2.0"
  s.add_runtime_dependency "pkce_challenge"
  s.add_runtime_dependency "faraday-follow_redirects"
  s.add_runtime_dependency "httparty", "~> 0.24.0"

  s.add_dependency "rails", ">= 7.0.4"
  s.add_dependency "jwt", "~> 2.2"
  
  s.add_development_dependency "rspec", "~> 3.6", ">= 3.6.0"

  s.files = Dir.glob(['lib/**/*', 'kinde_api/**/*', 'config/**/*', 'app/**/*']).reject do |f|
    File.directory?(f) || f.start_with?('kinde_api/spec/')
  end
  
  s.test_files    = `find spec/* #{SDK_PATH}/spec/*`.split("\n")
  s.executables   = []
  s.require_paths = %W[lib #{SDK_PATH}/lib]
end