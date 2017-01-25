testing
testPing
	self assert: client isConnected.
	self assert: client ping