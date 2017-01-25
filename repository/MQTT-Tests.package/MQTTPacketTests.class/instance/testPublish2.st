testing
testPublish2
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet id: 321.
	packet topic: 'ab'.
	packet message: 'message' asByteArray.
	packet qualityOfService: MQTTPacket exactlyOnce.
	self assert: packet hasId.
	self assert: packet id equals: 321.
	self assert: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket exactlyOnce.
	self assert: packet topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: packet hasId.
	self assert: packet id equals: 321.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket exactlyOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	self assert: readPacket equals: packet