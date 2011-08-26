require 'test/unit'
require 'foundry/syncproducer'
require 'foundry/callback'
require './examples/sleepyjob'


class SyncProducerTest < Test::Unit::TestCase
  def test_true_producer
    callback = Foundry::Callback.new
    test_job = SleepyJob.new
    ret = test_job.process({"sleep"=>1},callback.uuid)
    assert ret
    ret = Foundry::Callback.wait_for(Resque.redis,callback.uuid)
    assert ret
  end
 
  def test_false_producer
    callback = Foundry::Callback.new
    test_job = BadSleepyJob.new
    ret = test_job.process({"sleep"=>1},callback.uuid)
    assert ret
    ret = Foundry::Callback.wait_for(Resque.redis,callback.uuid)
    assert_equal ret, false
  end
  
end

