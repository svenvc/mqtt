printing
printInfoOn: stream
	super printInfoOn: stream.
	self hasReturnCodes
		ifTrue: [ 
			stream space.
			self returnCodes printElementsOn: stream ]