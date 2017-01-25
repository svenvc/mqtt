testing
testPublishReceived
	| packet bytes |
	packet := MQTTPublishReceived new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[80 2 1 65].
	packet := MQTTPacket fromByteArray: #[80 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishReceived new id: 321; yourself)