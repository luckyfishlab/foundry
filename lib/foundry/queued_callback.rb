require 'redis'
require 'uuid'
require 'json'

module Foundry
  # Callback provides a mechanism to signal that a job
  # is done 
  class QueuedCallback
    attr_reader :uuid

    def initialize
      generator = UUID.new
      @uuid = generator.generate
    end

    # Called by the producer's worker
    def self.done(redis,id,val)
      #puts "QueuedCallback Signaling done for ID: #{id}"
      r = Redis.new(redis)
      r.lrange("foundry:queuedcallback:#{id}",0,-1)
      r.lpush("foundry:queuedcallback:#{id}", [val].to_json)
      r.ltrim("foundry:queuedcallback:#{id}",0,0)
      #p r.lrange("foundry:queuedcallback:#{id}",0,-1)
    end
    
    # Used by the processor to sync on a producer
    def self.wait_for(redis,id)
      #puts "QueuedCallback Waiting for ID: #{id}"
      r = Redis.new(redis)
      ret = r.blpop("foundry:queuedcallback:#{id}",0)
      #puts "QueuedCallback received #{ret}"
      JSON.parse(ret[-1])[0]
    end
  end
end
