"
Connect to iot.eclipse.org
"
Class {
	#name : #MQTTExperimentalClientTests1,
	#superclass : #MQTTExperimentalClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTExperimentalClientTests1 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTExperimentalClientTests1 >> host [
	^ 'iot.eclipse.org'
]
