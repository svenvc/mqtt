initialize-release
keepalive: seconds
	self assert: (seconds between: 0 and: 16rFFFF).
	keepalive := seconds