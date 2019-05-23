"
Connect to test.mosquitto.org
"
Class {
	#name : #MQTTPrimitiveClientTests2,
	#superclass : #MQTTPrimitiveClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTPrimitiveClientTests2 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTPrimitiveClientTests2 >> host [
	^ 'test.mosquitto.org'
]
