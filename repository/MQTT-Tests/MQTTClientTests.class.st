"
MQTTClient unit tests.

Unless you are happy with the default, 

	MQTTClientTests url: 'mqtt://localhost:1883'.
	
i.e. you have a local MQTT server running on the default port,
you have to set the connection URL for unit tests.
Here are some examples that have been known to work as some point:

	MQTTClientTests url: 'mqtt://iot.eclipse.org:1883'.

	MQTTClientTests url: 'mqtt://test.mosquitto.org:1883'.

	MQTTClientTests url: 'mqtt://broker.mqtt-dashboard.com:1883'.

"
Class {
	#name : #MQTTClientTests,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#classVars : [
		'Url'
	],
	#category : #'MQTT-Tests'
}

{ #category : #accessing }
MQTTClientTests class >> url [
	"Return the connection URL for MQTTClients in the unit tests.
	The default corresponds with GitHub Actions' CI's requirements."
	
	^ Url ifNil: [ Url := 'mqtt://localhost:' ]
]

{ #category : #accessing }
MQTTClientTests class >> url: url [
	"Set the connection URL for MQTTClients in the unit tests."
	
	Url := url
]

{ #category : #accessing }
MQTTClientTests >> message [
	^ 'abc' asByteArray
]

{ #category : #accessing }
MQTTClientTests >> producerClientId [
	^ 'ClientProducer' , 999 atRandom asString
]

{ #category : #running }
MQTTClientTests >> setUp [
	client := MQTTClient url: MQTTClientTests url.
	[ client open ] on: ConnectionTimedOut , AssertionFailure , ConnectionClosed do: [ self skip ] 
]

{ #category : #accessing }
MQTTClientTests >> systemTopic [
	^ '$SYS/#'
]

{ #category : #running }
MQTTClientTests >> tearDown [
	client close.
	super tearDown
]

{ #category : #testing }
MQTTClientTests >> testDurableSubscription [
	| packet clientId |
	"basic client configuration, close it since it was opened automatically"
	client atLeastOnce.
	self assert: client isConnected.
	client close.
	"use a unique client id for the durable subscription"
	clientId := 'pharo-client-', 1e6 atRandom asString.
	"connect with the client id and subscribe using the same QoS, the session should be new"
	client clientId: clientId; cleanSession: false.
	packet := client open.
	self deny: packet sessionPresent. 
	self assert: (client subscribeToTopic: self topic qos: client qualityOfService).
	client close.
	"now set another client id and ask for a clean session, then send a message, nobody is listening"
	client clientId: nil; cleanSession: true.
	packet := client open.
	self deny: packet sessionPresent. 
	self assert: (client sendMessage: self message toTopic: self topic).
	client close.
	"the session was queued for our client id, reconnect with our client id, requesting an existing session"
	client clientId: clientId; cleanSession: false.
	packet := client open.
	self assert: packet sessionPresent.
	"we should now get the previously sent message that we missed"
	packet := client readMessage.
	self assert: packet isApplicationMessage.
	self assert: packet contents equals: self message.
	self assert: packet topic equals: self topic.
	self assert: (client unsubscribeFromTopic: self topic)
]

{ #category : #testing }
MQTTClientTests >> testOneQoS0 [
	| packet |
	client atMostOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readMessage.
	self assert: packet isApplicationMessage.
	self assert: packet contents equals: self message.
	self assert: packet topic equals: self topic.
	self assert: (client unsubscribeFromTopic: self topic)
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
MQTTClientTests >> testOneQoS1 [
	| packet |
	client atLeastOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readMessage.
	self assert: packet isApplicationMessage.
	self assert: packet contents equals: self message.
	self assert: packet topic equals: self topic.
	self assert: (client unsubscribeFromTopic: self topic)
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
MQTTClientTests >> testOneQoS2 [
	| packet |
	client exactlyOnce.
	self assert: client isConnected.
	self assert: (client subscribeToTopic: self topic).
	self assert: (client sendMessage: self message toTopic: self topic).
	packet := client readMessage.
	self assert: packet isApplicationMessage.
	self assert: packet contents equals: self message.
	self assert: packet topic equals: self topic.
	self assert: (client unsubscribeFromTopic: self topic)
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

{ #category : #testing }
MQTTClientTests >> testPing [
	self assert: client isConnected.
	self assert: client ping
]

{ #category : #testing }
MQTTClientTests >> testTwoPartiesBatchQoS0 [
	| data received |
	data := Integer primesUpTo: 100.
	client atMostOnce; subscribeToTopic: self topic.
	[ 
		| client2 |
		client2 := MQTTClient url: client url.
		client2 clientId: self producerClientId; open; atMostOnce.
		data do: [ :each | 
			each milliSeconds wait. 
			client2 sendMessage: each asByteArray toTopic: self topic ].
		client2 sendMessage: 'quit' asByteArray toTopic: self topic.
		client2 close ] fork.
	received := Array streamContents: [ :out |
		client runWith: [ :message | 
			message contents asString = 'quit' ifTrue: [ ConnectionClosed signal ].
			out nextPut: message contents asInteger ] ].	
	self assert: data equals: received
]

{ #category : #testing }
MQTTClientTests >> testTwoPartiesBatchQoS1 [
	| data received |
	data := Integer primesUpTo: 100.
	client atLeastOnce; subscribeToTopic: self topic.
	[ 
		| client2 |
		client2 := MQTTClient url: client url.
		client2 clientId: self producerClientId; open; atMostOnce.
		data do: [ :each | 
			each milliSeconds wait. 
			client2 sendMessage: each asByteArray toTopic: self topic ].
		client2 sendMessage: 'quit' asByteArray toTopic: self topic.
		client2 close ] fork.
	received := Array streamContents: [ :out |
		client runWith: [ :message | 
			message contents asString = 'quit' ifTrue: [ ConnectionClosed signal ].
			out nextPut: message contents asInteger ] ].	
	self assert: data equals: received
]

{ #category : #testing }
MQTTClientTests >> testTwoPartiesBatchQoS2 [
	| data received |
	data := Integer primesUpTo: 100.
	client exactlyOnce; subscribeToTopic: self topic.
	[ 
		| client2 |
		client2 := MQTTClient url: client url.
		client2 clientId: self producerClientId; open; atMostOnce.
		data do: [ :each | 
			each milliSeconds wait. 
			client2 sendMessage: each asByteArray toTopic: self topic ].
		client2 sendMessage: 'quit' asByteArray toTopic: self topic.
		client2 close ] fork.
	received := Array streamContents: [ :out |
		client runWith: [ :message | 
			message contents asString = 'quit' ifTrue: [ ConnectionClosed signal ].
			out nextPut: message contents asInteger ] ].	
	self assert: data equals: received
]

{ #category : #accessing }
MQTTClientTests >> topic [
	^ 'q123'
]
