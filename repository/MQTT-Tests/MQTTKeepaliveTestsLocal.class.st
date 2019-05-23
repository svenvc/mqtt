"
Connect to localhost

Make sure to run a local MQTT broker !
"
Class {
	#name : #MQTTKeepaliveTestsLocal,
	#superclass : #MQTTKeepaliveTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTKeepaliveTestsLocal class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTKeepaliveTestsLocal >> host [
	^ 'localhost'
]
