printing
printInfoOn: stream
	stream nextPut: $#.
	self hasId
		ifTrue: [ stream print: self id ]