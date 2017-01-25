initialize-release
readFrom: binaryStream
	| remainingLength topicFilter qos |
	remainingLength := super readFrom: binaryStream.
	remainingLength := remainingLength - self variableHeaderLength.
	[ remainingLength > 0 ] whileTrue: [ 
		topicFilter := self readStringFrom: binaryStream.
		qos := binaryStream next.
		self addTopicFilter: topicFilter withQoS: qos.
		remainingLength := remainingLength - (self encodedStringLength: topicFilter) - 1 ] 