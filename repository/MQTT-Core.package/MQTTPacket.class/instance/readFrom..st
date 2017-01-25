initialize-release
readFrom: binaryStream
	"Read/parse a binary representation of me from binaryStream and return it"
	
	^ self readRemainingLengthFrom: binaryStream