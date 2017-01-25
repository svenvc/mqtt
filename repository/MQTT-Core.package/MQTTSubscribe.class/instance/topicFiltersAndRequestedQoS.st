accessing
topicFiltersAndRequestedQoS
	^ topicFiltersAndRequestedQoS ifNil: [ topicFiltersAndRequestedQoS := OrderedCollection new ]