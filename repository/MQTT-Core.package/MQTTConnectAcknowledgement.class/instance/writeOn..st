writing
writeOn: binaryStream
	super writeOn: binaryStream.
	binaryStream nextPut: self sessionPresent asBit.
	binaryStream nextPut: self returnCode 