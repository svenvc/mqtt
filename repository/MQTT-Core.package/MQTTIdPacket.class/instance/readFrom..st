initialize-release
readFrom: binaryStream
	| remainingLength |
	remainingLength := super readFrom: binaryStream.
	self readVariableHeaderFrom: binaryStream.
	^ remainingLength