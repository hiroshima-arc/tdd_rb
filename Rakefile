require 'rake/testtask'

task default: [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir['./api/**.rb']
  test.verbose = true
end
