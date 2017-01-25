testing
testPublishAcknowledgement
	| packet bytes |
	packet := MQTTPublishAcknowledgement new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[64 2 1 65].
	packet := MQTTPacket fromByteArray: #[64 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishAcknowledgement new id: 321; yourself)