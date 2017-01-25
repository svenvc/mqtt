initialize-release
readFrom: binaryStream
	self assert: (super readFrom: binaryStream) = self remainingLength.
	self sessionPresent: binaryStream next = 1. 
	self returnCode: binaryStream next