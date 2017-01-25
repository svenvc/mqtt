initialize-release
readVariableHeaderFrom: binaryStream
	self isIdRequired
		ifTrue: [ self id: (self readInt16From: binaryStream) ]