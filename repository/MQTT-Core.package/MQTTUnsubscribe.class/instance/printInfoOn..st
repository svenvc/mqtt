printing
printInfoOn: stream
	super printInfoOn: stream.
	self hasTopicFilters
		ifTrue: [ 
			stream space.
			self topics printElementsOn: stream ]