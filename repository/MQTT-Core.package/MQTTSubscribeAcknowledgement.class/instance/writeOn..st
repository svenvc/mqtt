writing
writeOn: binaryStream
	super writeOn: binaryStream.
	binaryStream nextPutAll: self returnCodes