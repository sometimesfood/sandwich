require 'rake/testtask'

namespace :gem do
  desc 'Build chef-sandwich gem'
  task :build do
    sh 'gem build chef-sandwich.gemspec'
  end
end

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end
