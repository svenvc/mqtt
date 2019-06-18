"
Connect to broker.mqtt-dashboard.com
"
Class {
	#name : #MQTTPrimitiveClientTests3,
	#superclass : #MQTTPrimitiveClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTPrimitiveClientTests3 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTPrimitiveClientTests3 >> host [
	^ 'broker.mqtt-dashboard.com'
]

{ #category : #running }
MQTTPrimitiveClientTests3 >> setUp [
	client := self clientClass new.
	client host: self host.
	client timeout: 30.
	[ client open ] on: ConnectionTimedOut , AssertionFailure , ConnectionClosed do: [ self skip ]
]

{ #category : #testing }
MQTTPrimitiveClientTests3 >> testOneQoS2 [
	"This cannot succeed since broker.mqtt-dashboard.com interleaves certain responses"
	self skip
]
