$: << File.expand_path("./lib")

require 'resque'
require 'foundry'
require './sleepyjob'


class CommitPhase < Foundry::QueuedPhase
  def executePhase(context)
    puts "Start commit phase."
    puts "Commit -- #{context.class}:#{context} "

    processor = Foundry::Processor.new(SleepyJob.new())
    ret = processor.execute(context)
    puts "End commit phase with context: #{context.class}:#{context} return value #{ret}"   
    ret
  end
end



class SecondaryPhase < Foundry::QueuedPhase
  def executePhase(context)
    puts "Start secondary phase."
    puts "secondary -- #{context.class}:#{context} "

    job = SleepyJob.new()
   
    processor = Foundry::ParallelProcessor.new([job,job])
    context["sleep"] = context["sleep"] * 2
    processor.execute(context)

    puts "End secondary phase with context: #{context.class}:#{context} "   
    true
  end
end


def tickle_me(x)
  while 1
     #puts "Tickle tickle ... sleep for 5"
     sleep(5)
  end
end

def join_all
  main = Thread.main
  current = Thread.current
  all = Thread.list
  
  all.each { |t| t.join unless t == current or t == main }
end


p2 = SecondaryPhase.new(nil)
p1 = CommitPhase.new(p2)

t3 = Thread.new(1) {
  tickle_me(1)
}

job1 = Hash.new()
job1["ID"] = 1
job1["sleep"] = 10

job2 = {"ID"=> 2, "sleep" => 25}
job3 = {"ID"=> 3, "sleep" => 13}
job4 = {"ID"=> 4, "sleep" => 3}

p1.execute(job1)
p1.execute(job2)
p1.execute(job3)
sleep(15)
p1.execute(job4)
join_all

