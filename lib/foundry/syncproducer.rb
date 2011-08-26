require 'resque'
require 'foundry/callback'

module Foundry
  # Base class for creating synchronous jobs
  # out of async workers
  # Create a class method execute_job to
  # use
  class SyncProducer 
 
    # Process is called by the producer on the client
    def process(context, callback_id)
      # enqueue the job
      Resque.enqueue(self.class, context, callback_id)
      return true
    end
    
    # called by the worker
    def self.perform(context, callback_id)
      begin
        ret = self.execute_job(context)
        #puts "execute job returned #{ret}"
      rescue
        ret = false
        #puts "Exception raised!!!"
      ensure
        Foundry::Callback.done(Resque.redis, callback_id, ret)
      end
    end
   
    # Override me in the subclass
    def self.execute_job(context)
    end
  end
end
