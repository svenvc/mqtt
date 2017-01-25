input/output
readPacket
	| packet |
	packet := MQTTPacket readFrom: connection.
	self log: [ 'Read ', packet printString ].
	^ packet