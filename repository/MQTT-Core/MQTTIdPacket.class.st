"
I am MQTTIdPacket.
I am an MQTTPacket.
I am abstract. Consider me as an implementation detail.

I hold an optional id.

Some types of MQTT Control Packets contain a variable header component. It resides between the fixed header and the payload. The content of the variable header varies depending on the Packet type. The Packet Identifier field of variable header is common in several packet types.

The Client and Server assign Packet Identifiers independently of each other. As a result, Client Server pairs can participate in concurrent message exchanges using the same Packet Identifiers.
"
Class {
	#name : #MQTTIdPacket,
	#superclass : #MQTTPacket,
	#instVars : [
		'id'
	],
	#category : 'MQTT-Core'
}

{ #category : #comparing }
MQTTIdPacket >> = anObject [
	^ self class = anObject class and: [ self id = anObject id ]
]

{ #category : #testing }
MQTTIdPacket >> hasId [
	^ self id notNil
]

{ #category : #comparing }
MQTTIdPacket >> hash [
	^ self id hash
]

{ #category : #accessing }
MQTTIdPacket >> id [
	^ id
]

{ #category : #'initialize-release' }
MQTTIdPacket >> id: integer [
	self assert: (integer between: 0 and: 16rffff).
	id := integer
]

{ #category : #testing }
MQTTIdPacket >> isIdRequired [
	^ true
]

{ #category : #printing }
MQTTIdPacket >> printInfoOn: stream [
	self hasId
		ifTrue: [ stream nextPut: $#; print: self id ]
]

{ #category : #printing }
MQTTIdPacket >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	self printInfoOn: stream.
	stream nextPut: $)
]

{ #category : #'initialize-release' }
MQTTIdPacket >> readFrom: binaryStream [
	| remainingLength |
	remainingLength := super readFrom: binaryStream.
	self readVariableHeaderFrom: binaryStream.
	^ remainingLength
]

{ #category : #'initialize-release' }
MQTTIdPacket >> readVariableHeaderFrom: binaryStream [
	self isIdRequired
		ifTrue: [ self id: (self readInt16From: binaryStream) ]
]

{ #category : #accessing }
MQTTIdPacket >> variableHeaderLength [
	^ 2
]

{ #category : #writing }
MQTTIdPacket >> writeOn: binaryStream [
	super writeOn: binaryStream.
	self writeVariableHeaderOn: binaryStream
]

{ #category : #writing }
MQTTIdPacket >> writeVariableHeaderOn: binaryStream [
	self isIdRequired ifTrue: [ self writeInt16: self id on: binaryStream ]
]
