"
I am MQTTPublish.
I am an MQTT(Id)Packet.

I hold the application message itself (#message) which is a byte array and the topic string (#string). I hold the #duplicate and #retain flags as well as the #qualityOfService.

A PUBLISH Control Packet is sent from a Client to a Server or from Server to a Client to transport an Application Message.

If the DUP flag is set to 0, it indicates that this is the first occasion that the Client or Server has attempted to send this MQTT PUBLISH Packet. If the DUP flag is set to 1, it indicates that this might be re-delivery of an earlier attempt to send the Packet.
 
The DUP flag MUST be set to 1 by the Client or Server when it attempts to re-deliver a PUBLISH Packet [MQTT-3.3.1.-1]. The DUP flag MUST be set to 0 for all QoS 0 messages.
 
The value of the DUP flag from an incoming PUBLISH packet is not propagated when the PUBLISH Packet is sent to subscribers by the Server. The DUP flag in the outgoing PUBLISH packet is set independently to the incoming PUBLISH packet, its value MUST be determined solely by whether the outgoing PUBLISH packet is a retransmission

The quality of service field indicates the level of assurance for delivery of an Application Message.

If the RETAIN flag is set to 1, in a PUBLISH Packet sent by a Client to a Server, the Server MUST store the Application Message and its QoS, so that it can be delivered to future subscribers whose subscriptions match its topic name. When a new subscription is established, the last retained message, if any, on each matching topic name MUST be sent to the subscriber]. If the Server receives a QoS 0 message with the RETAIN flag set to 1 it MUST discard any message previously retained for that topic. It SHOULD store the new QoS 0 message as the new retained message for that topic, but MAY choose to discard it at any time - if this happens there will be no retained message for that topic.

When sending a PUBLISH Packet to a Client the Server MUST set the RETAIN flag to 1 if a message is sent as a result of a new subscription being made by a Client. It MUST set the RETAIN flag to 0 when a PUBLISH Packet is sent to a Client because it matches an established subscription regardless of how the flag was set in the message it received.

A PUBLISH Packet with a RETAIN flag set to 1 and a payload containing zero bytes will be processed as normal by the Server and sent to Clients with a subscription matching the topic name. Additionally any existing retained message with the same topic name MUST be removed and any future subscribers for the topic will not receive a retained message. “As normal” means that the RETAIN flag is not set in the message received by existing Clients. A zero byte retained message MUST NOT be stored as a retained message on the Server.
 
If the RETAIN flag is 0, in a PUBLISH Packet sent by a Client to a Server, the Server MUST NOT store the message and MUST NOT remove or replace any existing retained message.

The Topic Name identifies the information channel to which payload data is published.

The receiver of a PUBLISH Packet MUST respond according to  the QoS in the PUBLISH Packet:

0 - none
1 - PUBACK
2 - PUBREC

See also MQTTPublishAcknowledgement, MQTTPublishReceived, MQTTPublishRelease and MQTTPublishComplete. 
"
Class {
	#name : #MQTTPublish,
	#superclass : #MQTTIdPacket,
	#instVars : [
		'duplicate',
		'qualityOfService',
		'retain',
		'topic',
		'message'
	],
	#category : 'MQTT-Core'
}

{ #category : #comparing }
MQTTPublish >> = anObject [
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self class instVarNames allSatisfy: [ :each | 
		(self perform: each) = (anObject perform: each) ]
]

{ #category : #accessing }
MQTTPublish >> contents [
	^ self hasMessage ifTrue: [ self message ] ifFalse: [ #[ ] ]
]

{ #category : #accessing }
MQTTPublish >> duplicate [
	^ duplicate
]

{ #category : #'initialize-release' }
MQTTPublish >> duplicate: boolean [
	duplicate := boolean
]

{ #category : #accessing }
MQTTPublish >> flagBits [
	| bits |
	bits := (self qualityOfService bitAnd: 2r11) << 1.
	bits := bits bitAt: 1 put: self retain asBit.
	bits := bits bitAt: 4 put: self duplicate asBit.
	^ bits 
]

{ #category : #'initialize-release' }
MQTTPublish >> flagBits: integer [
	self qualityOfService: (integer bitAnd: 2r110) >> 1.
	self retain: (integer bitAt: 1) = 1.
	self duplicate: (integer bitAt: 4) = 1
]

{ #category : #testing }
MQTTPublish >> hasMessage [
	^ self message notNil
]

{ #category : #comparing }
MQTTPublish >> hash [
	^ self class instVarNames 
		inject: 0 
		into: [ :acc :each | acc bitXor: (self perform: each) hash ]
]

{ #category : #'initialize-release' }
MQTTPublish >> initialize [
	super initialize.
	duplicate := retain := false.
	qualityOfService := 0
]

{ #category : #testing }
MQTTPublish >> isApplicationMessage [
	^ true
]

{ #category : #testing }
MQTTPublish >> isIdRequired [
	^ self qualityOfService > 0
]

{ #category : #accessing }
MQTTPublish >> message [
	^ message
]

{ #category : #'initialize-release' }
MQTTPublish >> message: bytes [
	message := bytes
]

{ #category : #accessing }
MQTTPublish >> messageSize [
	^ self hasMessage ifTrue: [ self message size ] ifFalse: [ 0 ]
]

{ #category : #accessing }
MQTTPublish >> payloadLength [
	^ self hasMessage 
		ifTrue: [ self message size ] 
		ifFalse: [ 0 ]
]

{ #category : #printing }
MQTTPublish >> printInfoOn: stream [
	super printInfoOn: stream.
	stream
		space; nextPutAll: self topic;
		space; print: self messageSize; nextPutAll: 'B';
		space; << 'QoS='; print: self qualityOfService.
	self duplicate ifTrue: [ stream << ' Duplicate' ].
	self retain ifTrue: [ stream << ' Retain' ]
		 
]

{ #category : #accessing }
MQTTPublish >> qualityOfService [
	^ qualityOfService
]

{ #category : #'initialize-release' }
MQTTPublish >> qualityOfService: integer [
	self assert: (self class qualityOfServiceLevels includes: integer).
	qualityOfService := integer
]

{ #category : #'initialize-release' }
MQTTPublish >> readFrom: binaryStream [
	| remainingLength messageLength |
	remainingLength := super readFrom: binaryStream.
	messageLength := remainingLength - self variableHeaderLength.
	messageLength > 0
		ifTrue: [ self message: (binaryStream next: messageLength) ].
	self assert: (self remainingLength = remainingLength)
]

{ #category : #'initialize-release' }
MQTTPublish >> readVariableHeaderFrom: binaryStream [
	self topic: (self readStringFrom: binaryStream).
	super readVariableHeaderFrom: binaryStream
]

{ #category : #accessing }
MQTTPublish >> response [
	self qualityOfService = 1
		ifTrue: [ ^ MQTTPublishAcknowledgement new id: self id; yourself ].
	self qualityOfService = 2
		ifTrue: [ ^ MQTTPublishReceived new id: self id; yourself ].
	^ nil
]

{ #category : #accessing }
MQTTPublish >> retain [
	^ retain
]

{ #category : #'initialize-release' }
MQTTPublish >> retain: boolean [
	^ retain := boolean
]

{ #category : #accessing }
MQTTPublish >> topic [
	^ topic
]

{ #category : #'initialize-release' }
MQTTPublish >> topic: string [
	topic := string
]

{ #category : #accessing }
MQTTPublish >> typeTag [
	^ #publish
]

{ #category : #accessing }
MQTTPublish >> variableHeaderLength [
	| length |
	length := self encodedStringLength: self topic.
	^ self isIdRequired 
		ifTrue: [ length + 2 ]
		ifFalse: [ length ]
]

{ #category : #writing }
MQTTPublish >> writeOn: binaryStream [
	super writeOn: binaryStream.
	self hasMessage
		ifTrue: [ binaryStream nextPutAll: self message ] 
]

{ #category : #writing }
MQTTPublish >> writeVariableHeaderOn: binaryStream [
	self writeString: self topic on: binaryStream.
	super writeVariableHeaderOn: binaryStream 
]
