require 'rake/testtask'

desc 'Build chef-sandwich gem'
task :gem do
  sh 'gem build chef-sandwich.gemspec'
end

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end
