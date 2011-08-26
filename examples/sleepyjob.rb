$: << File.expand_path("./lib")

require 'foundry'

class SleepyJob < Foundry::SyncProducer
  @queue = "simple_task"

  def self.execute_job(context)
    puts "SleepyJob (#{context})"
    sleep(context["sleep"])
    return true
  end
  
end

class BadSleepyJob < Foundry::SyncProducer
  @queue = "simple_task"

  def self.execute_job(context)
    puts "BadSleepyJob (#{context})"
    sleep(context["sleep"])
    return false
  end
  
end


class ExceptionSleepyJob < Foundry::SyncProducer
  @queue = "simple_task"

  def self.execute_job(context)
    puts "ExceptionSleepyJob (#{context})"
    sleep(context["sleep"])
    raise ArgumentError, "We want to fail here!"
    
    return false
  end
  
end

