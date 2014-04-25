require "rubygems"
require "eventmachine"
require "json"
class StubClient
  def initialize(file,input)
	StubClientHandler.input=input
        @file=file
  end
  def run
	EM.run do
		(0...StubClientHandler.input.size).each do 
			puts "connecting #{@file}"
			EM.connect_unix_domain(@file, StubClientHandler)
		end
	end
  end
  def output
	StubClientHandler.output
  end
end
class StubClientHandler < EventMachine::Connection
  include EM::P::ObjectProtocol
  def serializer
    JSON
  end
  @@in=[]
  @@out=[]
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
     data=@@in.slice!(0) 
     send_object data
     puts "server connected, data sent #{data.to_json}"
  end
  def receive_object(obj)
    puts "RECEIVED DATA"
    @@out << obj
  end

  def unbind
    puts "client disconnected."
  end
end
