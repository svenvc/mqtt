"
I am MQTTSubscribe.
I am an MQTT(Id)Packet.

The SUBSCRIBE Packet is sent from the Client to the Server to create one or more Subscriptions. Each Subscription registers a Client’s interest in one or more Topics. The Server sends PUBLISH Packets to the Client in order to forward Application Messages that were published to Topics that match these Subscriptions. The SUBSCRIBE Packet also specifies (for each Subscription) the maximum QoS with which the Server can send Application Messages to the Client.

See also MQTTSubscribeAcknowledgement
"
Class {
	#name : #MQTTSubscribe,
	#superclass : #MQTTIdPacket,
	#instVars : [
		'topicFiltersAndRequestedQoS'
	],
	#category : 'MQTT-Core'
}

{ #category : #comparing }
MQTTSubscribe >> = anObject [
	^ super = anObject and: [ self topicFiltersAndRequestedQoS = anObject topicFiltersAndRequestedQoS ]
]

{ #category : #'initialize-release' }
MQTTSubscribe >> addTopicFilter: string withQoS: qos [
	self assert: (self class qualityOfServiceLevels includes: qos).
	self topicFiltersAndRequestedQoS add: string -> qos
]

{ #category : #enumerating }
MQTTSubscribe >> doTopicFiltersAndQoS: block [
	self hasTopicFiltersAndQoS
		ifTrue: [ 
			self topicFiltersAndRequestedQoS do: [ :each | 
				block value: each key value: each value ] ]
]

{ #category : #accessing }
MQTTSubscribe >> flagBits [
	^ 2r0010
]

{ #category : #testing }
MQTTSubscribe >> hasTopicFiltersAndQoS [
	^ topicFiltersAndRequestedQoS isEmptyOrNil not
]

{ #category : #comparing }
MQTTSubscribe >> hash [
	^ super hash bitXor: self topicFiltersAndRequestedQoS hash
]

{ #category : #accessing }
MQTTSubscribe >> payloadLength [
	^ self topics sum: [ :each | (self encodedStringLength: each) + 1 ]
]

{ #category : #printing }
MQTTSubscribe >> printInfoOn: stream [
	super printInfoOn: stream.
	self hasTopicFiltersAndQoS 
		ifTrue: [
			stream space.
			self topicFiltersAndRequestedQoS printElementsOn: stream ]
]

{ #category : #'initialize-release' }
MQTTSubscribe >> readFrom: binaryStream [
	| remainingLength topicFilter qos |
	remainingLength := super readFrom: binaryStream.
	remainingLength := remainingLength - self variableHeaderLength.
	[ remainingLength > 0 ] whileTrue: [ 
		topicFilter := self readStringFrom: binaryStream.
		qos := binaryStream next.
		self addTopicFilter: topicFilter withQoS: qos.
		remainingLength := remainingLength - (self encodedStringLength: topicFilter) - 1 ] 
]

{ #category : #accessing }
MQTTSubscribe >> response [
	| acknowledgement |
	acknowledgement := MQTTSubscribeAcknowledgement new.
	acknowledgement id: self id.
	self doTopicFiltersAndQoS: [ :topicFilter :qos |
		acknowledgement addReturnCode: qos ].
	^ acknowledgement 
]

{ #category : #accessing }
MQTTSubscribe >> topicFiltersAndRequestedQoS [
	^ topicFiltersAndRequestedQoS ifNil: [ topicFiltersAndRequestedQoS := OrderedCollection new ]
]

{ #category : #accessing }
MQTTSubscribe >> topics [
	^ self topicFiltersAndRequestedQoS collect: #key
]

{ #category : #accessing }
MQTTSubscribe >> typeTag [
	^ #subscribe
]

{ #category : #writing }
MQTTSubscribe >> writeOn: binaryStream [
	super writeOn: binaryStream.
	self doTopicFiltersAndQoS: [ :topicFilter :qos |
		self writeString: topicFilter on: binaryStream.
		binaryStream nextPut: qos ]
]
