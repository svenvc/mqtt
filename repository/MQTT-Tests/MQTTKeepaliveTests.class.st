"
Test keepalive, these tests are slow (20s).

I am using

	MQTTClientTests url
	
as connection URL.
"
Class {
	#name : #MQTTKeepaliveTests,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'MQTT-Tests'
}

{ #category : #accessing }
MQTTKeepaliveTests class >> defaultTimeLimit [
	^ 30 seconds
]

{ #category : #accessing }
MQTTKeepaliveTests >> keepalive [
	^ 5
]

{ #category : #running }
MQTTKeepaliveTests >> setUp [
	super setUp.
	client := MQTTClient url: MQTTClientTests url.
	client timeout: self timeout.
	client keepalive: self keepalive.
	[ client open ] on: ConnectionTimedOut , AssertionFailure , ConnectionClosed do: [ self skip ] 
]

{ #category : #running }
MQTTKeepaliveTests >> tearDown [
	client close.
	super tearDown
]

{ #category : #testing }
MQTTKeepaliveTests >> testOne [
	"This test takes about 20 seconds"
	self assert: client isConnected.
	self assert: client ping.
	"There are no messages to read, time out 4 times after 5 seconds, 20 seconds"
	4 timesRepeat: [ 
		[ client readMessage ] on: ConnectionTimedOut do: [ #ignore ] ].
	"During those 20 seconds, ping/pong keepalive, set at 5 seconds, will continue"
	self assert: client isConnected.
	self assert: client ping
	
]

{ #category : #accessing }
MQTTKeepaliveTests >> timeout [
	^ 5
]
