"
Test keepalive, these tests are slow
"
Class {
	#name : #MQTTKeepaliveTests,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : 'MQTT-Tests'
}

{ #category : #accessing }
MQTTKeepaliveTests class >> defaultTimeLimit [
	^ 30 seconds
]

{ #category : #testing }
MQTTKeepaliveTests class >> isAbstract [
	^ true
]

{ #category : #accessing }
MQTTKeepaliveTests >> host [
	self subclassResponsibility  
]

{ #category : #accessing }
MQTTKeepaliveTests >> keepalive [
	^ 5
]

{ #category : #accessing }
MQTTKeepaliveTests >> message [
	^ 'abc' asByteArray
]

{ #category : #running }
MQTTKeepaliveTests >> setUp [
	client := MQTTExperimentalClient new.
	client host: self host.
	client timeout: self timeout.
	client keepalive: self keepalive.
	client open
]

{ #category : #running }
MQTTKeepaliveTests >> tearDown [
	client close
]

{ #category : #testing }
MQTTKeepaliveTests >> testOne [
	self assert: client isConnected.
	self assert: client ping.
	4 timesRepeat: [ 
		[ client readMessage ] on: ConnectionTimedOut do: [ ] ].
	self assert: client isConnected.
	self assert: client ping
	
]

{ #category : #accessing }
MQTTKeepaliveTests >> timeout [
	^ 5
]

{ #category : #accessing }
MQTTKeepaliveTests >> topic [
	^ 'q123'
]
