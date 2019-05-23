"
I am MQTTSubscribeAcknowledgement.
I am an MQTT(Id)Packet.

A SUBACK Packet is sent by the Server to the Client to confirm receipt and processing of a SUBSCRIBE Packet.
 
A SUBACK Packet contains a list of return codes, that specify the maximum QoS level that was granted in each Subscription that was requested by the SUBSCRIBE.

The order of return codes in the SUBACK Packet MUST match the order of Topic Filters in the SUBSCRIBE Packet.

See also MQTTSubscribe
"
Class {
	#name : #MQTTSubscribeAcknowledgement,
	#superclass : #MQTTIdPacket,
	#instVars : [
		'returnCodes'
	],
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTSubscribeAcknowledgement class >> failure [
	^ 128
]

{ #category : #accessing }
MQTTSubscribeAcknowledgement class >> returnCodeValues [
	^ self qualityOfServiceLevels , #( 128 )
]

{ #category : #accessing }
MQTTSubscribeAcknowledgement class >> returnCodes [
	"Known return codes, index -> meaning"
	
	^ {
		0 -> 'Success - Maximum QoS 0'.
		1 -> 'Success - Maximum QoS 1'.
		2 -> 'Success - Maximum QoS 2'.
		128 -> 'Failure' } asDictionary
]

{ #category : #comparing }
MQTTSubscribeAcknowledgement >> = anObject [
	^ super = anObject and: [ self returnCodes = anObject returnCodes ]
]

{ #category : #'initialize-release' }
MQTTSubscribeAcknowledgement >> addReturnCode: code [
	self assert: (self class returnCodeValues includes: code).
	self returnCodes add: code
]

{ #category : #testing }
MQTTSubscribeAcknowledgement >> hasReturnCodes [
	^ returnCodes isEmptyOrNil not
]

{ #category : #comparing }
MQTTSubscribeAcknowledgement >> hash [
	^ super hash bitXor: self returnCodes hash
]

{ #category : #testing }
MQTTSubscribeAcknowledgement >> isSubscription: index acceptedWithQoS: qos [
	| code |
	self hasReturnCodes ifFalse: [ ^ false ].
	code := self returnCodes at: index ifAbsent: [ ^ false ].
	^ code = qos
]

{ #category : #accessing }
MQTTSubscribeAcknowledgement >> payloadLength [
	^ returnCodes size
]

{ #category : #printing }
MQTTSubscribeAcknowledgement >> printInfoOn: stream [
	super printInfoOn: stream.
	self hasReturnCodes
		ifTrue: [ 
			stream space.
			self returnCodes printElementsOn: stream ]
]

{ #category : #'initialize-release' }
MQTTSubscribeAcknowledgement >> readFrom: binaryStream [
	| remainingLength |
	remainingLength := super readFrom: binaryStream.
	remainingLength := remainingLength - self variableHeaderLength.
	(binaryStream next: remainingLength) do: [ :each | self addReturnCode: each ]

]

{ #category : #accessing }
MQTTSubscribeAcknowledgement >> returnCodes [
	^ returnCodes ifNil: [ returnCodes := OrderedCollection new ]
]

{ #category : #accessing }
MQTTSubscribeAcknowledgement >> typeTag [
	^ #suback
]

{ #category : #writing }
MQTTSubscribeAcknowledgement >> writeOn: binaryStream [
	super writeOn: binaryStream.
	binaryStream nextPutAll: self returnCodes
]
