testing
testConnectAcknowledgementDefault
	| packet bytes |
	packet := MQTTConnectAcknowledgement new.
	self deny: packet sessionPresent.
	self assert: packet isAccepted.
	bytes := packet asByteArray.
	self assert: bytes equals: #[32 2 0 0].
	packet := MQTTIdPacket fromByteArray: #[32 2 0 0].
	self deny: packet sessionPresent.
	self assert: packet isAccepted.
	self assert: packet equals: MQTTConnectAcknowledgement new