require "rubygems"
require "eventmachine"
require "json"
class SharedChannels
	@@_input_channel=EM::Channel.new
	@@_output_channel=EM::Channel.new
	def self.output_channel
	  @@_output_channel
	end
	def self.input_channel
	  @@_input_channel
	end
end
class IPCServer
  def initialize(file,port)
	p "F #{file} P #{port}"
	File.umask 0000
	File.unlink(file) if File.exists?(file)
        @file=file
        @port=port
  end
  def run 
	EM.run do
		EventMachine::connect("127.0.0.1",@port, SocketClientHandler)
		EventMachine::start_unix_domain_server(@file, IPCServerHandler)
	end
  end
end
class IPCServerHandler < EventMachine::Connection
  include EM::P::ObjectProtocol
  def serializer
    JSON
  end
  def receive_object(obj)
    p "REcieved from IPC #{obj}"
    @subscription=SharedChannels.output_channel.subscribe{|msg| got_output_responce msg}
	@id=obj["id"]
	SharedChannels.input_channel.push(obj)
    end
    def got_output_responce(msg)
	if(msg["id"]==@id)
	  SharedChannels.output_channel.unsubscribe(@subscription)
	  send_object msg
	end
    end
    def unbind
      puts "[server] client disconnected."
    end
end
class SocketClientHandler < EventMachine::Connection
  include EM::P::ObjectProtocol
  def serializer
    JSON
  end
  def post_init
    @subscription=SharedChannels.input_channel.subscribe{|msg| got_input_responce msg}
  end
  def receive_object(obj)
    puts "got responce from stub"
    SharedChannels.output_channel.push(obj)
  end
  def got_input_responce(msg)
    puts "got IN channel data #{msg.inspect} ID:#{msg["id"]}"
    send_object msg
  end
  def unbind
    SharedChannels.input_channel.unsubscribe(@subscription)
    puts "[server] client disconnected."
  end
end
