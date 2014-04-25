require "rubygems"
require "eventmachine"
require "json"
class StubServer
  def initialize(port)
  @port=port
  end
  def run
	EM.run do
		EM.start_server("127.0.0.1", @port, StubServerHandler)
	end
	p "Stub server terminated"
  end
end
class StubServerHandler < EventMachine::Connection
  include EM::P::ObjectProtocol
  def serializer
    JSON
  end
  def post_init
     puts "STUB SEVER client connected"
  end
  def receive_object(obj)
    p "GOT #{obj}"
    EM::defer do
      sleep obj["id"].to_i
      obj["message"]="a "+obj["message"]
      p "Replying #{obj}"
      send_object(obj)
    end
    #close_connection_after_writing
  end

  def unbind
    puts "STUB SEVER client disconnected."
  end
end
