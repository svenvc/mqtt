input/output
readPacket
	| packet |
	packet := super readPacket.
	self touch.
	^ packet