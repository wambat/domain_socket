require 'StubServerTest'
When /^I send following commands to stub server from multiple threads$/ do |table|
  @client=StubServerTest.new(@socket,table.hashes)
  @client.run
end

