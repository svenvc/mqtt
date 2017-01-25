accessing
messageSize
	^ self hasMessage ifTrue: [ self message size ] ifFalse: [ 0 ]