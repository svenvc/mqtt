"
Superclass of MQTTPrimitiveClient tests
"
Class {
	#name : #MQTTPrimitiveClientTests,
	#superclass : #MQTTAbstractClientTests,
	#category : #'MQTT-Tests'
}

{ #category : #testing }
MQTTPrimitiveClientTests class >> isAbstract [
	^ true
]

{ #category : #accessing }
MQTTPrimitiveClientTests >> clientClass [
	^ MQTTPrimitiveClient 
]
