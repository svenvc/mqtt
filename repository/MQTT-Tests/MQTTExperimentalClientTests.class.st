"
Superclass of MQTTExperimentalClient tests
"
Class {
	#name : #MQTTExperimentalClientTests,
	#superclass : #MQTTClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTExperimentalClientTests class >> isAbstract [
	^ true
]

{ #category : #accessing }
MQTTExperimentalClientTests >> clientClass [
	^ MQTTExperimentalClient 
]

{ #category : #accessing }
MQTTExperimentalClientTests >> systemTopic [
	^ '$SYS/#'
]

{ #category : #testing }
MQTTExperimentalClientTests >> testOneQoS0Busy [
	| packet |
	client atMostOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self systemTopic).
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readSuchThat: [ :packetRead | 
		packetRead isApplicationMessage and: [ packetRead topic = self topic ] ].
	self assert: packet contents equals: self message.
	self assert: (client unsubscribeFromTopic: self topic).
	self assert: (client unsubscribeFromTopic: self systemTopic)
]

{ #category : #testing }
MQTTExperimentalClientTests >> testOneQoS1Busy [
	| packet |
	client atLeastOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self systemTopic).
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readSuchThat: [ :packetRead | 
		packetRead isApplicationMessage and: [ packetRead topic = self topic ] ].
	self assert: packet contents equals: self message.
	self assert: (client unsubscribeFromTopic: self topic).
	self assert: (client unsubscribeFromTopic: self systemTopic)
]

{ #category : #testing }
MQTTExperimentalClientTests >> testOneQoS2Busy [
	| packet |
	client exactlyOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self systemTopic).
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readSuchThat: [ :packetRead | 
		packetRead isApplicationMessage and: [ packetRead topic = self topic ] ].
	self assert: packet contents equals: self message.
	self assert: (client unsubscribeFromTopic: self topic).
	self assert: (client unsubscribeFromTopic: self systemTopic)
]
