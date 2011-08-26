require 'test/unit'
require 'foundry/phase'

class TruePhase < Foundry::Phase

  def executePhase(context)
    return true
  end
end

class FalsePhase < Foundry::Phase
  def executePhase(context)
    return false
  end
end

class PhaseTest < Test::Unit::TestCase
  def test_with_one_phase
    phase = TruePhase.new nil
    assert_equal true, phase.execute(nil)
  end
  
  def test_with_two_phase
    phase2 = TruePhase.new nil
    phase1 = FalsePhase.new phase2
    assert_equal false, phase1.execute(nil)
    
    phase4 = TruePhase.new nil
    phase3 = TruePhase.new phase4
    assert_equal true, phase3.execute(nil)
  end
end

