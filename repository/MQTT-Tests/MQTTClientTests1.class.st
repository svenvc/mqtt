"
Connect to iot.eclipse.org
"
Class {
	#name : #MQTTClientTests1,
	#superclass : #MQTTClientTests,
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTClientTests1 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTClientTests1 >> host [
	^ 'iot.eclipse.org'
]
