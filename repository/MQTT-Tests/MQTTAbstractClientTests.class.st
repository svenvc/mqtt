"
Superclass of client tests
"
Class {
	#name : #MQTTAbstractClientTests,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTAbstractClientTests class >> isAbstract [
	^ true
]

{ #category : #accessing }
MQTTAbstractClientTests >> clientClass [
	self subclassResponsibility  
]

{ #category : #accessing }
MQTTAbstractClientTests >> host [
	self subclassResponsibility  
]

{ #category : #accessing }
MQTTAbstractClientTests >> message [
	^ 'abc' asByteArray
]

{ #category : #running }
MQTTAbstractClientTests >> setUp [
	client := self clientClass new.
	client host: self host.
	[ client open ] on: ConnectionTimedOut , AssertionFailure , ConnectionClosed do: [ self skip ] 
]

{ #category : #running }
MQTTAbstractClientTests >> tearDown [
	client close
]

{ #category : #testing }
MQTTAbstractClientTests >> testDurableSubscription [
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
MQTTAbstractClientTests >> testOneQoS0 [
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
MQTTAbstractClientTests >> testOneQoS1 [
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
MQTTAbstractClientTests >> testOneQoS2 [
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
MQTTAbstractClientTests >> testPing [
	self assert: client isConnected.
	self assert: client ping
]

{ #category : #accessing }
MQTTAbstractClientTests >> topic [
	^ 'q123'
]
