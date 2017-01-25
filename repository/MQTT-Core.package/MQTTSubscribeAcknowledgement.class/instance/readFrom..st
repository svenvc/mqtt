initialize-release
readFrom: binaryStream
	| remainingLength |
	remainingLength := super readFrom: binaryStream.
	remainingLength := remainingLength - self variableHeaderLength.
	(binaryStream next: remainingLength) do: [ :each | self addReturnCode: each ]
