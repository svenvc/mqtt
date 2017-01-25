public
subscribeToTopic: topicFilter qos: qos
	"Subscribe to topicFilter at qos.
	The server/broker will send us messages matching topicFilter."
	
	| subscribe packet |
	subscribe := MQTTSubscribe new.
	subscribe id: self nextId.
	subscribe addTopicFilter: topicFilter withQoS: qos.
	self writePacket: subscribe.
	packet := self readPacket.
	self assert: packet = subscribe response.
	self subscriptions add: topicFilter.
	^ true