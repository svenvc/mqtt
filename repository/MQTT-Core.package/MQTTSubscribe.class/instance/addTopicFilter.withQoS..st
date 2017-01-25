initialize-release
addTopicFilter: string withQoS: qos
	self assert: (self class qualityOfServiceLevels includes: qos).
	self topicFiltersAndRequestedQoS add: string -> qos