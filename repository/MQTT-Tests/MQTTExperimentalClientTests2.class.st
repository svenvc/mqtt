"
Connect to test.mosquitto.org
"
Class {
	#name : #MQTTExperimentalClientTests2,
	#superclass : #MQTTExperimentalClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTExperimentalClientTests2 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTExperimentalClientTests2 >> host [
	^ 'test.mosquitto.org'
]
