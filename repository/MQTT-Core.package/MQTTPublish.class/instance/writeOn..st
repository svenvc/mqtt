writing
writeOn: binaryStream
	super writeOn: binaryStream.
	self hasMessage
		ifTrue: [ binaryStream nextPutAll: self message ] 