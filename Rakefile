require 'rake/testtask'
require 'sandwich/version'

desc "Build chef-sandwich-#{Sandwich::VERSION}.gem"
task :gem do
  sh 'gem build chef-sandwich.gemspec'
end

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end
