require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = ['spec/*_spec.rb', 'kinde_api/spec/*_spec.rb', 'kinde_api/spec/*/*_spec.rb']
  end
  task default: :spec
end
