"
Superclass of client tests
"
Class {
	#name : #MQTTClientTests,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTClientTests class >> isAbstract [
	^ true
]

{ #category : #accessing }
MQTTClientTests >> clientClass [
	self subclassResponsibility  
]

{ #category : #accessing }
MQTTClientTests >> host [
	self subclassResponsibility  
]

{ #category : #accessing }
MQTTClientTests >> message [
	^ 'abc' asByteArray
]

{ #category : #running }
MQTTClientTests >> setUp [
	client := self clientClass new.
	client host: self host.
	client open
]

{ #category : #running }
MQTTClientTests >> tearDown [
	client close
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
MQTTClientTests >> testPing [
	self assert: client isConnected.
	self assert: client ping
]

{ #category : #accessing }
MQTTClientTests >> topic [
	^ 'q123'
]
