public
unsubscribeFromTopic: topicFilter
	"Unsubscribe frin topicFilter.
	The server/broker will no longer send us messages matching topicFilter."

	| unsubscribe packet |
	unsubscribe := MQTTUnsubscribe new.
	unsubscribe id: self nextId.
	unsubscribe addTopicFilter: topicFilter.
	self writePacket: unsubscribe.
	packet := self readPacket.
	self assert: packet = unsubscribe response.
	self subscriptions remove: topicFilter.
	^ true