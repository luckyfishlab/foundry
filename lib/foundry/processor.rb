#require 'foundry/callback'

module Foundry
  # Process a single async producer as synchronous
  # Execute blocks until we receive notice producer is
  # finished via Foundry::Callback.
  class Processor
    def initialize(producer)
      @producer = producer
    end
    
    # create a callback, process, waitfor callback
    # to be signaled
    def execute(context)
      callback = Foundry::Callback.new    
      if @producer.process(context,callback.uuid) == true
        ret = Foundry::Callback.wait_for(Resque.redis, callback.uuid)
        return ret
      end
      return false
    end
  end

  # Processes 1 or more async producers as synchronous
  # Execute blocks until all producers have finished
  class ParallelProcessor
    def initialize(producers=[])
      @producers = producers
      @jobs_started = 0
      # We use a single callback and
      # share it among all producers
      @processor_uuid = Foundry::Callback.new
    end
    
    # Start all the producers
    def execute(context)
      @producers.each { |p|
        p.process(context, @processor_uuid.uuid)
        @jobs_started += 1
      }
      
      # wait until we get signaled for each producer
      # process
      while @jobs_started > 0
        Foundry::Callback.wait_for(Resque.redis, @processor_uuid.uuid)
        @jobs_started -= 1
      end  
        
    end
  end
end




