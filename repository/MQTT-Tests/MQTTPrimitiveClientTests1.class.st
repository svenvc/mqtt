"
Connect to iot.eclipse.org
"
Class {
	#name : #MQTTPrimitiveClientTests1,
	#superclass : #MQTTPrimitiveClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTPrimitiveClientTests1 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTPrimitiveClientTests1 >> host [
	^ 'iot.eclipse.org'
]
