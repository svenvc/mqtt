testing
testSubscribe
	| packet bytes readPacket |
	packet := MQTTSubscribe new.
	packet id: 321.
	packet addTopicFilter: 'ab' withQoS: MQTTPacket atMostOnce.
	packet addTopicFilter: 'cd' withQoS: MQTTIdPacket atLeastOnce.
	packet addTopicFilter: 'ef' withQoS: MQTTIdPacket exactlyOnce.
	self assert: packet id equals: 321.
	self assert: packet topics equals: #(ab cd ef) asOrderedCollection.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: readPacket id equals: 321.
	self assert: readPacket equals: packet.
	self assert: readPacket topics equals: #(ab cd ef) asOrderedCollection 
