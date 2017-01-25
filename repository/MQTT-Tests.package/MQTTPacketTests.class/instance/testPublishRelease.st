testing
testPublishRelease
	| packet bytes |
	packet := MQTTPublishRelease new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[98 2 1 65].
	packet := MQTTPacket fromByteArray: #[98 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishRelease new id: 321; yourself)