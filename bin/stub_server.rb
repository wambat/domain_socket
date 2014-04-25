# "ABSTRACT" server stub
# USAGE : bin/stub_server.rb (start|stop) port
require "StubServer"
require "rubygems"
require "daemon_spawn"
class MyServer < DaemonSpawn::Base

    def start(args)
	s=StubServer.new(ARGV[0])
	s.run
    end

    def stop
      # stop your bad self
    end
  end

dir=File.expand_path('..',__FILE__)
p dir
  MyServer.spawn!(:log_file => dir+'/stub_server.log',
                  :pid_file => dir+'/stub_server.pid',
                  :sync_log => true,
                  :working_dir => File.dirname(__FILE__))
