testing
testOneQoS0
	| packet |
	client atMostOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readMessage.
	self assert: packet isApplicationMessage.
	self assert: packet contents equals: self message.
	self assert: packet topic equals: self topic.
	self assert: (client unsubscribeFromTopic: self topic)