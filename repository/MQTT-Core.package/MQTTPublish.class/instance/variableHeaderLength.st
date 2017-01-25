accessing
variableHeaderLength
	| length |
	length := self encodedStringLength: self topic.
	^ self isIdRequired 
		ifTrue: [ length + 2 ]
		ifFalse: [ length ]