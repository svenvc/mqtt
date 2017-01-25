enumerating
doTopicFilters: block
	self hasTopicFilters ifTrue: [ self topicFilters do: block ]