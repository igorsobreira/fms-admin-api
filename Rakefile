require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  puts 'running tests'
  t.libs << 'lib'
  t.libs << 'tests'
  t.test_files = FileList['tests/*_tests.rb', 'tests/*_test.rb']
  t.verbose = true
end
