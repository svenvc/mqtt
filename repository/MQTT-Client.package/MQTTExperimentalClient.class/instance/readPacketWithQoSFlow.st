input/output
readPacketWithQoSFlow
	| packet |
	packet := self readPacket.
	"Handle normal first phase responses (PUBACK, PINGRESP)"
	packet response ifNotNil: [ :expectedResponse |
		self writePacket: expectedResponse.
		"Handle QoS=2 second phase"
		expectedResponse response ifNotNil: [ :expectedResponse2 |
			"1. packet=PUBLISH (in) 2. response=PUBREC (out) 
			3. response2=PUBREL=packet2 (in) 4. finally send PUBCOMP (out)"
			"recursive call, final write happens there as well"
			self readSuchThat: [ :packetRead | packetRead = expectedResponse2 ] ] ].
	^ packet