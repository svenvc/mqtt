testing
testOneQoS2Busy
	| packet |
	client exactlyOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self systemTopic).
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readSuchThat: [ :packetRead | 
		packetRead isApplicationMessage and: [ packetRead topic = self topic ] ].
	self assert: packet contents equals: self message.
	self assert: (client unsubscribeFromTopic: self topic).
	self assert: (client unsubscribeFromTopic: self systemTopic)