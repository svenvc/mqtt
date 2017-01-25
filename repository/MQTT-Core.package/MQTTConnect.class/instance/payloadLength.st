accessing
payloadLength
	| length |
	length := self encodedStringLength: self clientId.
	self hasWill
		ifTrue: [ 
			length := length 
								+ (self encodedStringLength: self willTopic) 
								+ (self encodedBytesLength: self willMessage) ].
	self hasUsername
		ifTrue: [ length := length + (self encodedStringLength: self username) ].
	self hasPassword
		ifTrue: [ length := length + (self encodedBytesLength: self password) ].
	^ length