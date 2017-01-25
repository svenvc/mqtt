input/output
writePacketWithQoSFlow: packet
	self writePacket: packet.
	"QoS=1 normal responses (PUBACK)"
	packet response ifNotNil: [ :expectedResponse1 |
		"QoS=2 second phase will be handled in #readSuchThat:"
		self readSuchThat: [ :packetRead | packetRead = expectedResponse1 ] ]