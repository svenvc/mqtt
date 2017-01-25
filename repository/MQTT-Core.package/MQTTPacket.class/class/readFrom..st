instance creation
readFrom: binaryStream
	"Read/parse a binary representation of an instance of me from binaryStream and return it"

	| byte type flagBits packetClass packet |
	byte := binaryStream next.
	type := byte >> 4.
	flagBits := byte bitAnd: 2r1111.
	packetClass := self concreteSubclasses at: type.
	packet := packetClass new.
	packet flagBits: flagBits.
	packet readFrom: binaryStream.
	^ packet
