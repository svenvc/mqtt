"
Superclass of MQTTClient tests
"
Class {
	#name : #MQTTClientTests,
	#superclass : #MQTTAbstractClientTests,
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTClientTests class >> isAbstract [
	^ true
]

{ #category : #accessing }
MQTTClientTests >> clientClass [
	^ MQTTClient 
]

{ #category : #accessing }
MQTTClientTests >> systemTopic [
	^ '$SYS/#'
]

{ #category : #testing }
MQTTClientTests >> testOneQoS0Busy [
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
MQTTClientTests >> testOneQoS1Busy [
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
MQTTClientTests >> testOneQoS2Busy [
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
