require 'StubServer'
require 'StubClient'
require 'IPCServer'
Given /^servers configured$/ do
  @ipcfile="/tmp/test11223344.sock"
  @socket="99999"
end

Given /^IPC server is running$/ do
  Thread.new do
    @ipcserver=IPCServer.new(@ipcfile,@socket)
    @ipcserver.run
  end
  sleep(1)
end

Given /^stub socket server is running$/ do
  Thread.new do
    socketstubserver=StubServer.new(@socket)
    socketstubserver.run
  end
  #sleep(1)
end

When /^I send following commands to server from multiple threads$/ do |table|
  # table is a Cucumber::Ast::Table
  #pending # express the regexp above with the code you wish you had
  
  #table.hashes
  @client=StubClient.new(@ipcfile,table.hashes)
  @client.run
end

When /^I wait for (\d+) seconds$/ do |arg1|
  sleep arg1.to_i
  p "ZZZZ"
end

Then /^I should have responces processed ordered by timeout$/ do
  p "OUT #{@client.inspect}"
  @client.output[0]["message"].should=='a first'
  @client.output[1]["message"].should=='a middle'
  @client.output[2]["message"].should=='a last'
  #pending # express the regexp above with the code you wish you had
end

