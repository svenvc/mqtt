writing
writeVariableHeaderOn: binaryStream
	self writeString: self topic on: binaryStream.
	super writeVariableHeaderOn: binaryStream 