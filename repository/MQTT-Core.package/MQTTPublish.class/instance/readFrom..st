initialize-release
readFrom: binaryStream
	| remainingLength messageLength |
	remainingLength := super readFrom: binaryStream.
	messageLength := remainingLength - self variableHeaderLength.
	messageLength > 0
		ifTrue: [ self message: (binaryStream next: messageLength) ].
	self assert: (self remainingLength = remainingLength)