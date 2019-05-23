"
Connect to iot.eclipse.org
"
Class {
	#name : #MQTTKeepaliveTests1,
	#superclass : #MQTTKeepaliveTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTKeepaliveTests1 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTKeepaliveTests1 >> host [
	^ 'iot.eclipse.org'
]
