initialize-release
readFrom: binaryStream
	| remainingLength connectFlags |
	remainingLength := super readFrom: binaryStream.
	self validateProtocolFrom: binaryStream.
	connectFlags := binaryStream next.
	self setFlagsFrom: connectFlags.
	self readPayloadFrom: binaryStream using: connectFlags.
	self assert: self remainingLength = remainingLength