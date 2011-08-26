require 'test/unit'
require 'foundry'
require 'foundry/callback'

class CallbackTest < Test::Unit::TestCase
  def test_with_simple_value
    callback = Foundry::Callback.new
    redis = Resque.redis
    
    t1 = Thread.new(callback.uuid) { |id|
      ret = Foundry::Callback.wait_for(redis,id)
      assert_equal true, ret
    }
    t2 = Thread.new(callback.uuid) { |id|
      sleep(2)
      Foundry::Callback.done(redis, id, true)
    }
    
    t2.join
    t1.join
  end
 
  def test_with_complex_value
    expected = [{"complex"=>true, "something"=> 23},-0.314,"This is my string"]
    callback = Foundry::Callback.new
    
    redis = Resque.redis
        
    t1 = Thread.new(callback.uuid) { |id|
      ret = Foundry::Callback.wait_for(redis,id)
      assert_equal expected, ret
    }
    t2 = Thread.new(callback.uuid) { |id|
      sleep(2)
      Foundry::Callback.done(redis, id, expected)
    }
    
    t2.join
    t1.join
  end

end

