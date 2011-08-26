require 'foundry/callback'

module Foundry
  # EventedPhase uses internal events to transition between phases
  class EventedPhase
    attr_reader :callback
    attr_reader :errors
            
    def initialize(phase=nil,klass=Foundry::Callback)
      @next = phase
      @callback = klass.new
      @klass = klass
      @thread = Thread.new { process_loop }
    end
   
    # Main processing thread for a phase. This loop executes
    # the phase indefinitely. 
    # TODO: Add an exit criteria by adding setters/getters 
    #       for a shutdown state and check it in this
    #       loop.
    def process_loop
      while 1
        #puts "Process loop -- waiting on next job"
        context = wait_for_next(@callback.uuid)

        #puts "#{callback.uuid} -- Executing phase: #{self.class} with #{context.class}:#{context}"
        ret = executePhase(context)
        #puts "executePhase(#{context}) returned #{ret}"
        if  ret == false
          #puts " Don't go to the next phase!!"
          @errors += 1
          next 
        end
        #puts "Process loop -- done with execute phase"
        if @next != nil
          signal_done(@next.callback.uuid, context)
        end
      end
    end
    
    # tell yourself to start given the context
    def execute(context)
      signal_done( @callback.uuid, context)
      #puts "#{@callback.uuid} -- called #{self.class}.execute(#{context.class}.#{context})"
    end
    
    def wait_for_next(callback)
      ret = @klass.wait_for( Resque.redis, callback)
      ret
    end    
        
    def signal_done(callback, context) 
      @klass.done( Resque.redis, callback, context)    
    end
    
  end
end
