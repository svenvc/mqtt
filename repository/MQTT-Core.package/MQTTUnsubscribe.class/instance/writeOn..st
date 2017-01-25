writing
writeOn: binaryStream
	super writeOn: binaryStream.
	self doTopicFilters: [ :topicFilter |
		self writeString: topicFilter on: binaryStream ]