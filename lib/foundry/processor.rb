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
end




