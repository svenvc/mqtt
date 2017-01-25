writing
writeInt16: integer on: binaryStream
	binaryStream 
		nextPut: (integer digitAt: 2); 
		nextPut: (integer digitAt: 1)
