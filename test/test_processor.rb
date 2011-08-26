require 'test/unit'
require 'foundry'

require './examples/sleepyjob'


class ProcessorTest < Test::Unit::TestCase
  def test_true_processor
    test_job = SleepyJob.new
    processor = Foundry::Processor.new(test_job)
    ret = processor.execute({"sleep"=>1})
    assert ret
  end
  
  def test_false_processor
    test_job = BadSleepyJob.new
    processor = Foundry::Processor.new(test_job)
    ret = processor.execute({"sleep"=>1})
    assert_equal ret, false
  end
  
end

