writing
writeBytes: bytes on: binaryStream
	self assert: bytes size < 16rFFFF.
	self writeInt16: bytes size on: binaryStream.
	binaryStream nextPutAll: bytes 