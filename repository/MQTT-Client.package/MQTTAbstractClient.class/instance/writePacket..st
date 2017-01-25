input/output
writePacket: packet
	packet writeOn: connection.
	connection flush.
	self log: [ 'Wrote ', packet printString ]