require "StubServerTest"
c=StubServerTest.new(ARGV[0],[{"id"=>1,"message"=>"one"},
			      {"id"=>2,"message"=>"two"},
			      {"id"=>3,"message"=>"three"}
			      ])
c.run
