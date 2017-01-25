accessing
newPublishPacketToTopic: topicString
	| publish |
	publish := MQTTPublish new.
	publish topic: topicString.
	publish qualityOfService: self qualityOfService.
	publish isIdRequired ifTrue: [ publish id: self nextId ].
	^ publish
