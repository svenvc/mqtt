comparing
= anObject
	^ super = anObject and: [ self topicFiltersAndRequestedQoS = anObject topicFiltersAndRequestedQoS ]