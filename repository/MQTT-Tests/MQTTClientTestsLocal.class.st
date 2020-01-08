"
Connect to localhost

Make sure to run a local MQTT broker !
"
Class {
	#name : #MQTTClientTestsLocal,
	#superclass : #MQTTClientTests,
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTClientTestsLocal class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTClientTestsLocal >> host [
	^ 'localhost'
]

{ #category : #accessing }
MQTTClientTestsLocal >> producerClientId [
	^ self clientClass name asString, 'Producer'
]

{ #category : #testing }
MQTTClientTestsLocal >> testTwoPartiesBatchQoS0 [
	| data received |
	data := Integer primesUpTo: 100.
	client atMostOnce; subscribeToTopic: self topic.
	[ 
		| client2 |
		client2 := self clientClass new.
		client2 host: self host; clientId: self producerClientId; open; atMostOnce.
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
MQTTClientTestsLocal >> testTwoPartiesBatchQoS1 [
	| data received |
	data := Integer primesUpTo: 100.
	client atLeastOnce; subscribeToTopic: self topic.
	[ 
		| client2 |
		client2 := self clientClass new.
		client2 host: self host; clientId: self producerClientId; open; atLeastOnce.
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
MQTTClientTestsLocal >> testTwoPartiesBatchQoS2 [
	| data received |
	data := Integer primesUpTo: 100.
	client exactlyOnce; subscribeToTopic: self topic.
	[ 
		| client2 |
		client2 := self clientClass new.
		client2 host: self host; clientId: self producerClientId; open; exactlyOnce.
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
