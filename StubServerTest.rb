require "rubygems"
require "eventmachine"
require "json"
class StubServerTest
  def initialize(port,input)
	StubServerTestHandler.input=input
	@port=port
  end
  def run
	  EM.run do
		EM::connect("127.0.0.1",@port, StubServerTestHandler) 
	  end
	p "Stub test client terminated"
  end
  def output
	StubServerTestHandler.output
  end
end
class StubServerTestHandler < EventMachine::Connection
  @@in=[]
  @@out=[]
  include EM::P::ObjectProtocol
  def serializer
    JSON
  end
  def self.output
    @@out
  end
  def self.input
    @@in
  end
  def self.output=(i)
    @@out=i
  end
  def self.input=(i)
    @@in=i
  end
  def post_init
	(0...@@in.size).each {send_next}
  end
  def receive_object(obj)
    puts "RECEIVED OBJ #{obj}"
    @@out << obj
  end
  def send_next
     if(@@in.size > 0)
       data=@@in.slice!(0) 
       puts "SEND DATA #{data}"
       send_object data
#	sleep 0.5
     else
       #@timer.cancel
     end
  end

  def unbind
    puts "Test client disconnected."
  end
end
