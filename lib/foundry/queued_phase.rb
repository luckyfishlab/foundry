require 'foundry/callback'

module Foundry
  # QueuedPhase uses a queue to transition between phases
  # Keeping only the latest item on the queue
  class QueuedPhase < Foundry::EventedPhase
            
    def initialize(phase=nil)
      super(phase,Foundry::QueuedCallback)
    end
  end
end
