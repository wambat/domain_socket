# IPC test client
# USAGE : bin/ipc_test_client.rb unix-socket
require "StubClient"
c=StubClient.new(ARGV[0],[{"id"=>1,"message"=>"one"},
			      {"id"=>2,"message"=>"two"},
			      {"id"=>3,"message"=>"three"}
			      ])
c.run
