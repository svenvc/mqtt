enumerating
doTopicFiltersAndQoS: block
	self hasTopicFiltersAndQoS
		ifTrue: [ 
			self topicFiltersAndRequestedQoS do: [ :each | 
				block value: each key value: each value ] ]