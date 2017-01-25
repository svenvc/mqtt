accessing
payloadLength
	^ self hasMessage 
		ifTrue: [ self message size ] 
		ifFalse: [ 0 ]