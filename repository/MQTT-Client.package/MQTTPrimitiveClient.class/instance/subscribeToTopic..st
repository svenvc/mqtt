public
subscribeToTopic: topicFilter
	"Subscribe to topicFilter at my default QoS.
	The server/broker will send us messages matching topicFilter."
	
	^ self subscribeToTopic: topicFilter qos: self qualityOfService 