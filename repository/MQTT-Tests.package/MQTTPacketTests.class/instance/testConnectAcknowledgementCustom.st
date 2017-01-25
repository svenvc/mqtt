testing
testConnectAcknowledgementCustom
	| packet bytes readPacket |
	packet := MQTTConnectAcknowledgement new.
	packet returnCode: 5.
	packet sessionPresent: true.
	self assert: packet returnCode equals: 5.
	self assert: packet sessionPresent.
	self deny: packet isAccepted.
	bytes := packet asByteArray.
	self assert: bytes equals: #[32 2 1 5].
	readPacket := MQTTIdPacket fromByteArray: #[32 2 1 5].
	self assert: readPacket returnCode equals: 5.
	self assert: readPacket sessionPresent.
	self deny: readPacket isAccepted.
	self assert: readPacket equals: packet