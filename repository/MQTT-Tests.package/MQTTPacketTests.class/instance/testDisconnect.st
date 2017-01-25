testing
testDisconnect
	| packet bytes |
	packet := MQTTDisconnect new.
	bytes := packet asByteArray.
	self assert: bytes equals: #[224 0].
	packet := MQTTPacket fromByteArray: #[224 0].
	self assert: packet equals: MQTTDisconnect new