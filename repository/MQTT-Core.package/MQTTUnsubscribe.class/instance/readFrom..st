initialize-release
readFrom: binaryStream
	| remainingLength topicFilter |
	remainingLength := super readFrom: binaryStream.
	remainingLength := remainingLength - self variableHeaderLength.
	[ remainingLength > 0 ] whileTrue: [ 
		topicFilter := self readStringFrom: binaryStream.
		self addTopicFilter: topicFilter.
		remainingLength := remainingLength - (self encodedStringLength: topicFilter) ] 