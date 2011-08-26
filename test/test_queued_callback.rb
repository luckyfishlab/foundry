require 'test/unit'
require 'foundry/queued_callback'

class QueuedCallbackTest < Test::Unit::TestCase
  def test_with_simple_value
    callback = Foundry::QueuedCallback.new
    
    t1 = Thread.new(callback.uuid) { |id|
      ret = Foundry::QueuedCallback.wait_for(Resque.redis,id)
      assert_equal true, ret
    }
    t2 = Thread.new(callback.uuid) { |id|
      sleep(2)
      Foundry::QueuedCallback.done(Resque.redis, id, true)
    }
    
    t2.join
    t1.join
  end
 
  def test_with_complex_value
    expected = [{"complex"=>true, "something"=> 23},-0.314,"This is my string"]
    callback = Foundry::QueuedCallback.new
    
    t1 = Thread.new(callback.uuid) { |id|
      ret = Foundry::QueuedCallback.wait_for(Resque.redis,id)
      assert_equal expected, ret
    }
    t2 = Thread.new(callback.uuid) { |id|
      sleep(2)
      Foundry::QueuedCallback.done(Resque.redis, id, expected)
    }
    
    t2.join
    t1.join
  end

end

