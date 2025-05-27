require "bundler/gem_tasks"
require 'open-uri'
require 'fileutils'

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
    File.open("tmp/kinde-api-spec.yaml", "w") do |file|
      file.write(URI.open(spec_url).read)
    end
    puts "Spec downloaded to tmp/kinde-api-spec.yaml"
  end

  desc "Generate API client from OpenAPI spec"
  task :generate => :download_spec do
    puts "Generating API client..."
    # Using a hardcoded version for now - we can update this later to read from the gemspec
    version = "1.0.0"
    properties = [
      "gemName=kinde_api",
      "gemVersion=#{version}",
      "gemLicense=MIT",
      "gemHomepage=https://github.com/kinde-oss/kinde-ruby-sdk",
      "gemDescription='Ruby SDK for the Kinde Management API'",
      "gemAuthor=Kinde",
      "gemAuthorEmail=support@kinde.com"
    ].join(",")

    cmd = "npx @openapitools/openapi-generator-cli generate -i tmp/kinde-api-spec.yaml -g ruby -o kinde_api --additional-properties=\"#{properties}\""
    puts "Running command: #{cmd}"
    system(cmd)
  end

  desc "Clean up temporary files"
  task :clean do
    puts "Cleaning up temporary files..."
    FileUtils.rm_rf("tmp")
  end

  desc "Regenerate the API client from the latest OpenAPI spec"
  task :regenerate => [:generate, :clean]
end