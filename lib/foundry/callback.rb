require 'redis'
require 'uuid'
require 'json'

module Foundry
  # Callback provides a mechanism to signal that a job
  # is done 
  class Callback
    attr_reader :uuid

    def initialize
      generator = UUID.new
      @uuid = generator.generate
    end

    # Called by the producer's worker
    def self.done(redis,id,val)
      #puts "Callback Signaling done for ID: #{id} VAL: #{val}"
      r = Redis.new(redis)
      r.rpush("foundry:callback:#{id}", [val].to_json)
      #puts redis.lrange("foundry:callback:#{id}",0,-1)      
    end
    
    # Used by the processor to sync on a producer
    def self.wait_for(redis,id)
      #puts "Callback Waiting for ID: #{id}"
      r = Redis.new(redis)      
      ret = r.blpop("foundry:callback:#{id}",0)
      #puts "Callback received #{ret}"
      JSON.parse(ret[-1])[0]

    end
  end
end
