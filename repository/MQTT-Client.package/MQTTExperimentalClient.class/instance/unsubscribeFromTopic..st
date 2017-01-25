public
unsubscribeFromTopic: topicFilter
	"Unsubscribe frin topicFilter.
	The server/broker will no longer send us messages matching topicFilter."

	| unsubscribe expectedResponse |
	unsubscribe := MQTTUnsubscribe new.
	unsubscribe id: self nextId.
	unsubscribe addTopicFilter: topicFilter.
	self writePacket: unsubscribe.
	expectedResponse := unsubscribe response.
	self readSuchThat: [ :packet | packet = expectedResponse ].
	self subscriptions remove: topicFilter.
	^ true