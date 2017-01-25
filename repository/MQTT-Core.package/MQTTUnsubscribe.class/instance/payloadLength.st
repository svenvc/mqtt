accessing
payloadLength
	^ self topics sum: [ :each | (self encodedStringLength: each) ]