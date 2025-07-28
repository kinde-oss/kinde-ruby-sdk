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
  desc "Download the latest Management API spec from Kinde"
  task :download_spec do
    puts "Downloading Management API spec from Kinde..."
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
    puts "Management API spec downloaded to tmp/kinde-api-spec.yaml"
  end

  desc "Download the latest Frontend API spec from Kinde"
  task :download_frontend_spec do
    puts "Downloading Frontend API spec from Kinde..."
    spec_url = "https://api-spec.kinde.com/kinde-frontend-api-spec.yaml"
    FileUtils.mkdir_p("tmp")
    begin
      content = URI.open(spec_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER}).read
      # Basic validation that it's a YAML file
      raise "Invalid content" unless content.include?("openapi:") || content.include?("swagger:")
      File.open("tmp/kinde-frontend-api-spec.yaml", "w") { |file| file.write(content) }
    rescue => e
      puts "Failed to download frontend spec: #{e.message}"
      raise
    end
    puts "Frontend API spec downloaded to tmp/kinde-frontend-api-spec.yaml"
  end

  desc "Generate Management API client from OpenAPI spec"
  task :generate => :download_spec do
    puts "Generating Management API client..."
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
    puts "Management API client generated successfully in kinde_api/"
  end

  desc "Generate Frontend API client from OpenAPI spec"
  task :generate_frontend => :download_frontend_spec do
    puts "Generating Frontend API client..."
    # Read version from gemspec
    version = begin
      spec = Gem::Specification::load("kinde_sdk.gemspec")
      spec ? spec.version.to_s : "1.0.0"
    rescue
      "1.0.0"
    end
    
    # Generate Frontend API into temporary directory
    properties = [
      "gemName=kinde_frontend_api",
      "gemVersion=#{version}",
      "gemLicense=MIT",
      "gemHomepage=https://github.com/kinde-oss/kinde-ruby-sdk",
      "gemDescription='Ruby SDK for the Kinde Frontend API'",
      "gemAuthor=Kinde",
      "gemAuthorEmail=support@kinde.com",
      "useAutoload=true"
    ].join(",")

    cmd = "npx @openapitools/openapi-generator-cli generate -i tmp/kinde-frontend-api-spec.yaml -g ruby -o tmp-frontend --additional-properties=\"#{properties}\""
    puts "Running command: #{cmd}"
    unless system(cmd)
      raise "Frontend API generation failed with exit code #{$?.exitstatus}"
    end
    
    # Create Frontend directories following PHP pattern
    FileUtils.mkdir_p("kinde_api/lib/kinde_api/api/frontend")
    FileUtils.mkdir_p("kinde_api/lib/kinde_api/models/frontend")
    
    # Copy and transform API files to Frontend namespace
    if Dir.exist?("tmp-frontend/lib/kinde_frontend_api/api")
      Dir.glob("tmp-frontend/lib/kinde_frontend_api/api/*.rb").each do |file|
        basename = File.basename(file)
        dest = "kinde_api/lib/kinde_api/api/frontend/#{basename}"
        
        # Update the file content to use correct Frontend module namespace
        content = File.read(file)
        content.gsub!(/module KindeFrontendApi/, "module KindeApi::Frontend")
        content.gsub!(/KindeFrontendApi::/, "KindeApi::Frontend::")
        
        File.write(dest, content)
        puts "  Created: #{dest}"
      end
    end
    
    # Copy and transform Model files to Frontend namespace
    if Dir.exist?("tmp-frontend/lib/kinde_frontend_api/models")
      Dir.glob("tmp-frontend/lib/kinde_frontend_api/models/*.rb").each do |file|
        basename = File.basename(file)
        dest = "kinde_api/lib/kinde_api/models/frontend/#{basename}"
        
        # Update the file content to use correct Frontend module namespace
        content = File.read(file)
        content.gsub!(/module KindeFrontendApi/, "module KindeApi::Frontend")
        content.gsub!(/KindeFrontendApi::/, "KindeApi::Frontend::")
        
        File.write(dest, content)
        puts "  Created: #{dest}"
      end
    end
    
    puts "Frontend API client generated successfully in kinde_api/lib/kinde_api/api/frontend/"
  end

  desc "Clean up temporary files"
  task :clean do
    puts "Cleaning up temporary files..."
    FileUtils.rm_rf("tmp")
    FileUtils.rm_rf("tmp-frontend")
  end

  desc "Regenerate the Management API client from the latest OpenAPI spec"
  task :regenerate => [:generate, :clean]

  desc "Generate both Management and Frontend API clients"
  task :generate_all => [:generate, :generate_frontend]

  desc "Regenerate both Management and Frontend API clients from latest specs"
  task :regenerate_all => [:generate_all, :clean]
end