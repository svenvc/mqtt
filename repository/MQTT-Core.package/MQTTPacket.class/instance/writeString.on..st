writing
writeString: string on: binaryStream
	self writeBytes: string utf8Encoded on: binaryStream