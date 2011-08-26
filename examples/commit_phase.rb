$: << File.expand_path("./lib")

require 'resque'
require 'foundry'

class CommitPhase < Foundry::EventedPhase
  def executePhase(context)
    puts "Start commit phase with context: #{context}"
    sleep(Integer(context))  
    true
  end
end



class SecondaryPhase < Foundry::EventedPhase
  def executePhase(context)
    puts "Start secondary phase with context: #{context}"
    sleep(Integer(context))  
    true
  end
end


def tickle_me(x)
  while 1
     puts "Tickle tickle ... sleep for 5"
     sleep(5)
  end
end

def join_all
  main = Thread.main
  current = Thread.current
  all = Thread.list
  
  all.each { |t| t.join unless t == current or t == main }
end


p2 = SecondaryPhase.new(nil)
p1 = CommitPhase.new(p2)

t3 = Thread.new(p1) {
  tickle_me(p1)
}

p1.execute("10")
sleep(3)
p1.execute("15")
sleep(5)
p1.execute("20")
join_all

