module Foundry
  class Phase
    def intialize
      @next = nil
    end
      
    def initialize(phase)
      @next = phase
    end
   
    def execute(context)
      if executePhase(context) == false
         return false
      end
      
      if @next != nil
          @next.execute(context)
      end
      return true
    end   
  end
end
