# encoding: utf-8
require 'bundler'

Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = Dir["test/**/test_*.rb"].sort
  test.verbose = false
  test.warning = false
end

task default: [:test]
