writing
writeOn: binaryStream
	super writeOn: binaryStream.
	self doTopicFiltersAndQoS: [ :topicFilter :qos |
		self writeString: topicFilter on: binaryStream.
		binaryStream nextPut: qos ]