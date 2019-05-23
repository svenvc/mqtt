"
Connect to test.mosquitto.org
"
Class {
	#name : #MQTTKeepaliveTests2,
	#superclass : #MQTTKeepaliveTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTKeepaliveTests2 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTKeepaliveTests2 >> host [
	^ 'test.mosquitto.org'
]
