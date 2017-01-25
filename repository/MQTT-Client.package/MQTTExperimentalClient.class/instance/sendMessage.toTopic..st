public
sendMessage: bytes toTopic: topicString
	"Send a message consisting of bytes to topicString while handling QoS flows.
	Might fail with ConnectionTimedOut."

	| publish |
	publish := self newPublishPacketToTopic: topicString.
	publish message: bytes.
	self writePacket: publish.
	"QoS=1 normal responses (PUBACK)"
	publish response ifNotNil: [ :expectedResponse1 |
		"QoS=2 second phase will be handled in #readSuchThat:"
		self readSuchThat: [ :packet | packet = expectedResponse1 ] ].
	^ true