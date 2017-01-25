writing
writeOn: binaryStream
	"Write a binary representation of me on binaryStream"
	
	binaryStream nextPut: ((self typeValue << 4) bitXor: self flagBits).
	self writeRemainingLengthOn: binaryStream 