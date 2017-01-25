printing
printInfoOn: stream
	super printInfoOn: stream.
	self hasTopicFiltersAndQoS 
		ifTrue: [
			stream space.
			self topicFiltersAndRequestedQoS printElementsOn: stream ]