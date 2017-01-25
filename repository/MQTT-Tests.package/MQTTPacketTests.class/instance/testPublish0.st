testing
testPublish0
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet topic: 'ab'.
	packet message: 'message' asByteArray.
	self deny: packet hasId.
	self deny: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket atMostOnce.
	self assert: packet topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self deny: readPacket hasId.
	self deny: readPacket isIdRequired.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self assert: packet hasMessage.
	self assert: readPacket qualityOfService equals: MQTTPacket atMostOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	self assert: readPacket equals: packet
