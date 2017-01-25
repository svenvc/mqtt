testing
testUnsubscribeAcknowledgement
	| packet bytes |
	packet := MQTTUnsubscribeAcknownledgement new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[176 2 1 65].
	packet := MQTTPacket fromByteArray: #[176 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTUnsubscribeAcknownledgement new id: 321; yourself)