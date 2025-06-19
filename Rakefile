require "bundler/gem_tasks"
require 'open-uri'
require 'fileutils'
require 'openssl'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = ['spec/*_spec.rb', 'kinde_api/spec/*_spec.rb', 'kinde_api/spec/*/*_spec.rb']
    t.rspec_opts = '--require spec_helper' # Ensures spec/spec_helper.rb is loaded
  end
  task default: :spec
rescue LoadError
  # Handle case where rspec-core isn't available
end

namespace :api do
  desc "Download the latest OpenAPI spec from Kinde"
  task :download_spec do
    puts "Downloading OpenAPI spec from Kinde..."
    spec_url = "https://api-spec.kinde.com/kinde-combined-api-specs.yaml"
    FileUtils.mkdir_p("tmp")
    begin
      content = URI.open(spec_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER}).read
      # Basic validation that it's a YAML file
      raise "Invalid content" unless content.include?("openapi:") || content.include?("swagger:")
      File.open("tmp/kinde-api-spec.yaml", "w") { |file| file.write(content) }
    rescue => e
      puts "Failed to download spec: #{e.message}"
      raise
    end
    puts "Spec downloaded to tmp/kinde-api-spec.yaml"
  end

  desc "Generate API client from OpenAPI spec"
  task :generate => :download_spec do
    puts "Generating API client..."
    # Read version from gemspec
    version = begin
      spec = Gem::Specification::load("kinde_sdk.gemspec")
      spec ? spec.version.to_s : "1.0.0"
    rescue
      "1.0.0"
    end
    properties = [
      "gemName=kinde_api",
      "gemVersion=#{version}",
      "gemLicense=MIT",
      "gemHomepage=https://github.com/kinde-oss/kinde-ruby-sdk",
      "gemDescription='Ruby SDK for the Kinde Management API'",
      "gemAuthor=Kinde",
      "gemAuthorEmail=support@kinde.com",
      "useAutoload=true"
    ].join(",")

    cmd = "npx @openapitools/openapi-generator-cli generate -i tmp/kinde-api-spec.yaml -g ruby -o kinde_api --additional-properties=\"#{properties}\""
    puts "Running command: #{cmd}"
    unless system(cmd)
      raise "OpenAPI generation failed with exit code #{$?.exitstatus}"
    end
    puts "API client generated successfully in kinde_api/"
  end

  desc "Clean up temporary files"
  task :clean do
    puts "Cleaning up temporary files..."
    FileUtils.rm_rf("tmp")
  end

  desc "Regenerate the API client from the latest OpenAPI spec"
  task :regenerate => [:generate, :clean]
end