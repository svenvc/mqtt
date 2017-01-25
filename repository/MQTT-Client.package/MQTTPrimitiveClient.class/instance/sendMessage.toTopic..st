public
sendMessage: bytes toTopic: topicString
	"Send a message consisting of bytes to topicString while handling QoS flows.
	Might fail with ConnectionTimedOut."
	
	| publish packet |
	publish := self newPublishPacketToTopic: topicString.
	publish message: bytes.
	self writePacket: publish.
	"Handle normal responses (PUBACK)"
	publish response ifNotNil: [ :response |
		packet := self readPacket.
		self assert: packet = response.
		"Handle QoS=2 second phase"
		response response ifNotNil: [ :response2 | | packet2 |
			"1. publish=PUBLISH (out) 2. response=PUBREC=packet (in) 
			3. response2=PUBREL (out) 4. finally read PUBCOMP (in)"
			self writePacket: response2.
			packet2 := self readPacket.
			self assert: packet2 = response2 response ] ].
	^ true