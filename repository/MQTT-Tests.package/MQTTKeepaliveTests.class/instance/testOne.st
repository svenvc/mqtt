testing
testOne
	self assert: client isConnected.
	self assert: client ping.
	4 timesRepeat: [ 
		[ client readMessage ] on: ConnectionTimedOut do: [ ] ].
	self assert: client isConnected.
	self assert: client ping
	