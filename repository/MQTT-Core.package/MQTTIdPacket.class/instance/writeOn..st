writing
writeOn: binaryStream
	super writeOn: binaryStream.
	self writeVariableHeaderOn: binaryStream