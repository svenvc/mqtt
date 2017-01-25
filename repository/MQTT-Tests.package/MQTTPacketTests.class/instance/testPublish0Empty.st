testing
testPublish0Empty
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet topic: 'ab'.
	self deny: packet hasId.
	self deny: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self deny: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket atMostOnce.
	self assert: packet topic equals: 'ab'.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self deny: readPacket hasId.
	self deny: readPacket isIdRequired.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self deny: readPacket hasMessage.
	self assert: readPacket qualityOfService equals: MQTTPacket atMostOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: readPacket equals: packet
