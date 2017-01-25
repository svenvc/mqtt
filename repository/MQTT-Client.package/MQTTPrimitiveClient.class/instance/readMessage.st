public
readMessage
	"Read a message while handling the necessary QoS flows.
	Might fail with ConnectionTimedOut."
	
	| packet |
	packet := self readPacket.
	"Handle normal responses (PUBACK, PINGRESP)"
	packet response ifNotNil: [ :response |
		self writePacket: response.
		"Handle QoS=2 second phase"
		response response ifNotNil: [ :response2 | | packet2 |
			"1. packet=PUBLISH (in) 2. response=PUBREC (out) 
			3. response2=PUBREL=packet2 (in) 4. finally send PUBCOMP (out)"
			packet2 := self readPacket.
			self assert: packet2 = response2.
			self writePacket: packet2 response ] ].
	^ packet