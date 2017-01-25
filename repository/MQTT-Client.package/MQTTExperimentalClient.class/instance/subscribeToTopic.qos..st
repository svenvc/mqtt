public
subscribeToTopic: topicFilter qos: qos
	"Subscribe to topicFilter at qos.
	The server/broker will send us messages matching topicFilter."

	| subscribe expectedResponse |
	subscribe := MQTTSubscribe new.
	subscribe id: self nextId.
	subscribe addTopicFilter: topicFilter withQoS: qos.
	self writePacket: subscribe.
	expectedResponse := subscribe response.
	self readSuchThat: [ :packet | packet = expectedResponse ].
	self subscriptions add: topicFilter.
	^ true