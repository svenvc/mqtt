"
Connect to localhost

Make sure to run a local MQTT broker !
"
Class {
	#name : #MQTTPrimitiveClientTestsLocal,
	#superclass : #MQTTPrimitiveClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTPrimitiveClientTestsLocal class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTPrimitiveClientTestsLocal >> host [
	^ 'localhost'
]
