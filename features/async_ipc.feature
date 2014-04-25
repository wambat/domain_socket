Feature: Serving as IPC server
	In order to process my request
	As an IPC client
	I want to be connect to domain socket

	@servers
	Scenario: multiple connection to socket server
		Given servers configured
		And stub socket server is running
		And IPC server is running
		When I send following commands to server from multiple threads 
			| id 	  | message |
			| 3	  | last    |
			| 2 	  | middle  |
			| 1 	  | first   |
		And I wait for 5 seconds
		Then I should have responces processed ordered by timeout
