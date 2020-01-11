require 'rake/testtask'

task default: [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir['./api/test/**/*_test.rb','./docs/src/article//code/*.rb']
  test.verbose = true
end
