require "bundler/gem_tasks"

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