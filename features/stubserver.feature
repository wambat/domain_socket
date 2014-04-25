@stub
Feature: Serving as StubServer
	In order to ensure stub abstract server working
	As an Stub server client
	I want to be connect to socket

	@servers
	Scenario: multiple connection to stub server
		Given stub socket server is running
		When I send following commands to stub server from multiple threads 
			| id 	  | message |
			| 3	  | last    |
			| 2 	  | middle  |
			| 1 	  | first   |
		And I wait for 5 seconds
		Then I should have responces processed ordered by timeout
