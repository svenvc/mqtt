testing
testSubscribeAcknowledgement
	| packet bytes readPacket |
	packet := MQTTSubscribeAcknowledgement new.
	packet id: 321.
	packet addReturnCode: MQTTPacket atMostOnce.
	packet addReturnCode: MQTTPacket atLeastOnce.
	packet addReturnCode: MQTTIdPacket exactlyOnce.
	packet addReturnCode: MQTTSubscribeAcknowledgement failure.
	self assert: packet id equals: 321.
	self assert: packet returnCodes equals: { MQTTPacket atMostOnce. MQTTPacket atLeastOnce. MQTTIdPacket exactlyOnce. MQTTSubscribeAcknowledgement failure } asOrderedCollection.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: readPacket id equals: 321.
	self assert: readPacket equals: packet.
	self assert: readPacket returnCodes equals: { MQTTPacket atMostOnce. MQTTPacket atLeastOnce. MQTTIdPacket exactlyOnce. MQTTSubscribeAcknowledgement failure } asOrderedCollection.
