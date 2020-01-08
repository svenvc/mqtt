"
Connect to test.mosquitto.org
"
Class {
	#name : #MQTTClientTests2,
	#superclass : #MQTTClientTests,
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTClientTests2 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTClientTests2 >> host [
	^ 'test.mosquitto.org'
]
