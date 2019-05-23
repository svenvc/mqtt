"
I am MQTTUnsubscribe.
I am an MQTT(Id)Packet.

An UNSUBSCRIBE Packet is sent by the Client to the Server, to unsubscribe from topics.

See also MQTTUnsubscribeAcknowledgement
"
Class {
	#name : #MQTTUnsubscribe,
	#superclass : #MQTTIdPacket,
	#instVars : [
		'topicFilters'
	],
	#category : 'MQTT-Core'
}

{ #category : #comparing }
MQTTUnsubscribe >> = anObject [
	^ super = anObject and: [ self topicFilters = anObject topicFilters ]
]

{ #category : #'initialize-release' }
MQTTUnsubscribe >> addTopicFilter: string [
	self topicFilters add: string
]

{ #category : #enumerating }
MQTTUnsubscribe >> doTopicFilters: block [
	self hasTopicFilters ifTrue: [ self topicFilters do: block ]
]

{ #category : #accessing }
MQTTUnsubscribe >> flagBits [
	^ 2r0010
]

{ #category : #testing }
MQTTUnsubscribe >> hasTopicFilters [
	^ topicFilters isEmptyOrNil not
]

{ #category : #comparing }
MQTTUnsubscribe >> hash [
	^ super hash bitXor: self topicFilters hash
]

{ #category : #accessing }
MQTTUnsubscribe >> payloadLength [
	^ self topics sum: [ :each | (self encodedStringLength: each) ]
]

{ #category : #printing }
MQTTUnsubscribe >> printInfoOn: stream [
	super printInfoOn: stream.
	self hasTopicFilters
		ifTrue: [ 
			stream space.
			self topics printElementsOn: stream ]
]

{ #category : #'initialize-release' }
MQTTUnsubscribe >> readFrom: binaryStream [
	| remainingLength topicFilter |
	remainingLength := super readFrom: binaryStream.
	remainingLength := remainingLength - self variableHeaderLength.
	[ remainingLength > 0 ] whileTrue: [ 
		topicFilter := self readStringFrom: binaryStream.
		self addTopicFilter: topicFilter.
		remainingLength := remainingLength - (self encodedStringLength: topicFilter) ] 
]

{ #category : #accessing }
MQTTUnsubscribe >> response [
	^ MQTTUnsubscribeAcknownledgement new id: self id; yourself
]

{ #category : #accessing }
MQTTUnsubscribe >> topicFilters [
	^ topicFilters ifNil: [ topicFilters := OrderedCollection new ]
]

{ #category : #accessing }
MQTTUnsubscribe >> topics [
	^ self topicFilters 
]

{ #category : #accessing }
MQTTUnsubscribe >> typeTag [
	^ #unsubscribe
]

{ #category : #writing }
MQTTUnsubscribe >> writeOn: binaryStream [
	super writeOn: binaryStream.
	self doTopicFilters: [ :topicFilter |
		self writeString: topicFilter on: binaryStream ]
]
