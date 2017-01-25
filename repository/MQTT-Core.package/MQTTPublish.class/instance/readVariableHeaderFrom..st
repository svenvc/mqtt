initialize-release
readVariableHeaderFrom: binaryStream
	self topic: (self readStringFrom: binaryStream).
	super readVariableHeaderFrom: binaryStream