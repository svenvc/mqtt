testing
testPing
	| packet bytes |
	packet := MQTTPingRequest new.
	bytes := packet asByteArray.
	self assert: bytes equals: #[192 0].
	packet := MQTTPacket fromByteArray: #[192 0].
	self assert: packet equals: MQTTPingRequest new.
	
	packet := MQTTPingResponse new.
	bytes := packet asByteArray.
	self assert: bytes equals: #[208 0].
	packet := MQTTPacket fromByteArray: #[208 0].
	self assert: packet equals: MQTTPingResponse new.