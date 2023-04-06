# frozen_string_literal: true

SDK_PATH = "kinde-sdk"

$LOAD_PATH.push File.expand_path("lib", __dir__)
$LOAD_PATH.push File.expand_path("#{SDK_PATH}/lib", __dir__)

require "kinde_api/version"

Gem::Specification.new do |s|
  s.name        = "kinde_sdk"
  s.version     = KindeApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kinde Australia Pty Ltd"]
  s.email       = ["support@kinde.com"]
  s.homepage    = "https://kinde.com/"
  s.summary     = "Kinde Management API Ruby Gem"
  s.description = "Provides API to easy management your Kinde Businesses"
  s.license     = "MIT"
  s.required_ruby_version = ">= 2.7"

  s.add_runtime_dependency "typhoeus", "~> 1.0", ">= 1.0.1"
  s.add_runtime_dependency "oauth2", "~> 2.0"
  s.add_runtime_dependency "pkce_challenge"
  s.add_runtime_dependency "faraday-follow_redirects"

  s.add_development_dependency "rspec", "~> 3.6", ">= 3.6.0"

  s.files         = `find *`.split("\n").uniq.sort.reject(&:empty?)
  s.test_files    = `find spec/* #{SDK_PATH}/spec/*`.split("\n")
  s.executables   = []
  s.require_paths = %W[lib #{SDK_PATH}/lib]
end
