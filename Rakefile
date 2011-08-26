# encoding: utf-8

require 'rubygems'
require 'rake/testtask'
require 'resque/tasks'


require './examples/sleepyjob'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test*.rb'
  test.verbose = true
end


task :default => :test


