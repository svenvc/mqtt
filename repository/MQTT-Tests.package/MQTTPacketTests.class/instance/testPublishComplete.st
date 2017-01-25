testing
testPublishComplete
	| packet bytes |
	packet := MQTTPublishComplete new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[112 2 1 65].
	packet := MQTTPacket fromByteArray: #[112 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishComplete new id: 321; yourself)