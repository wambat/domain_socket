# "PROXY" server 
# USAGE : bin/ipc_server.rb (start|stop) unix-socket port
require "IPCServer"
require "rubygems"
require "daemon_spawn"
class MyServer < DaemonSpawn::Base

    def start(args)
	s=IPCServer.new(ARGV[0], ARGV[1])
	s.run
    end

    def stop
      # stop your bad self
    end
  end

dir=File.expand_path('..',__FILE__)
p dir
  MyServer.spawn!(:log_file => dir+'/ipc_server.log',
                  :pid_file => dir+'/ipc_server.pid',
                  :sync_log => true,
                  :working_dir => File.dirname(__FILE__))
