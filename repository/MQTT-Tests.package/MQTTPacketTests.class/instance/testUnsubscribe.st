testing
testUnsubscribe
	| packet bytes readPacket |
	packet := MQTTUnsubscribe new.
	packet id: 321.
	packet addTopicFilter: 'ab'.
	packet addTopicFilter: 'cd'.
	packet addTopicFilter: 'ef'.
	self assert: packet id equals: 321.
	self assert: packet topics equals: #(ab cd ef) asOrderedCollection.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: readPacket id equals: 321.
	self assert: readPacket equals: packet.
	self assert: readPacket topics equals: #(ab cd ef) asOrderedCollection 
