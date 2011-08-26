$: << File.expand_path("./lib")

require 'foundry'
require './sleepyjob'


params = { "sleep" => 10 }

a_job = SleepyJob.new()
b_job = SleepyJob.new()

myProc = Foundry::Processor.new(a_job)
my2ndProc = Foundry::Processor.new(BadSleepyJob.new())
my3rdProc = Foundry::Processor.new(ExceptionSleepyJob.new())

puts myProc.execute(params)
puts my2ndProc.execute(params)
puts my3rdProc.execute(params)

times = 0
while times>0
  myParallelProc = Foundry::ParallelProcessor.new( [a_job,
                                                    b_job,
                                                    a_job,
                                                    a_job,
                                                    b_job] )
  myParallelProc.execute(params)
  times -= 1
end
