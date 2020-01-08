"
Connect to broker.mqtt-dashboard.com
"
Class {
	#name : #MQTTClientTests3,
	#superclass : #MQTTClientTests,
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTClientTests3 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTClientTests3 >> host [
	^ 'broker.mqtt-dashboard.com'
]

{ #category : #running }
MQTTClientTests3 >> setUp [
	client := self clientClass new.
	client host: self host.
	client timeout: 30.
	[ client open ] on: ConnectionTimedOut , AssertionFailure , ConnectionClosed do: [ self skip ]
]
