"
I am MQTTConnectAcknowledgement.
I am an MQTTPacket.

I hold a return code (#returnCode) and a session present (#sessionPresent) flag. 

Use #isAccepted to test for sucess. See my class side's #returnCodes and #returnCodeValues for possible return codes. Use #returnCodeMeaning for a human readeable description.

The CONNACK Packet is the packet sent by the Server in response to a CONNECT Packet received from a Client. The first packet sent from the Server to the Client MUST be a CONNACK Packet.

If the Client does not receive a CONNACK Packet from the Server within a reasonable amount of time, the Client SHOULD close the Network Connection.

The Session Present flag enables a Client to establish whether the Client and Server have a consistent view about whether there is already stored Session state. Once the initial setup of a Session is complete, a Client with stored Session state will expect the Server to maintain its stored Session state. In the event that the value of Session Present received by the Client from the Server is not as expected, the Client can choose whether to proceed with the Session or to disconnect. The Client can discard the Session state on both Client and Server by disconnecting, connecting with Clean Session set to 1 and then disconnecting again. If a server sends a CONNACK packet containing a non-zero return code it MUST set Session Present to 0.

If a well formed CONNECT Packet is received by the Server, but the Server is unable to process it for some reason, then the Server SHOULD attempt to send a CONNACK packet containing the appropriate non-zero Connect return code.

If the Server accepts a connection with CleanSession set to 1, the Server MUST set Session Present to 0 in the CONNACK packet in addition to setting a zero return code in the CONNACK packet.

If the Server accepts a connection with CleanSession set to 0, the value set in Session Present depends on whether the Server already has stored Session state for the supplied client ID. If the Server has stored Session state, it MUST set Session Present to 1 in the CONNACK packet.

If the Server does not have stored Session state, it MUST set Session Present to 0 in the CONNACK packet. This is in addition to setting a zero return code in the CONNACK packet.

If a server sends a CONNACK packet containing a non-zero return code it MUST then close the Network Connection.

See also MQTTConnect.
"
Class {
	#name : #MQTTConnectAcknowledgement,
	#superclass : #MQTTPacket,
	#instVars : [
		'sessionPresent',
		'returnCode'
	],
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTConnectAcknowledgement class >> returnCodeValues [
	^ (0 to: self returnCodes size - 1) asArray
]

{ #category : #accessing }
MQTTConnectAcknowledgement class >> returnCodes [
	"Known return codes, the index equals the return code's integer value + 1"
	
	^ #( 
		'Connection Accepted' 
		'Connection Refused, unacceptable protocol version' 
		'Connection Refused, identifier rejected' 
		'Connection Refused, Server unavailable' 
		'Connection Refused, bad user name or password' 
		'Connection Refused, not authorized' )
]

{ #category : #comparing }
MQTTConnectAcknowledgement >> = anObject [
	^ self class = anObject class
		and: [ self returnCode = anObject returnCode
			and: [ self sessionPresent = anObject sessionPresent ] ]
]

{ #category : #comparing }
MQTTConnectAcknowledgement >> hash [
	^ self returnCode hash bitXor: self sessionPresent hash 
]

{ #category : #'initialize-release' }
MQTTConnectAcknowledgement >> initialize [
	super initialize.
	sessionPresent := false.
	returnCode := 0
]

{ #category : #testing }
MQTTConnectAcknowledgement >> isAccepted [
	^ self returnCode isZero
]

{ #category : #printing }
MQTTConnectAcknowledgement >> printOn: stream [
	super printOn: stream.
	stream
		nextPut: $(;
		nextPutAll: self returnCodeMeaning;
		nextPutAll: ' - ';
		nextPutAll:
				(self sessionPresent
						ifTrue: [ 'session present' ]
						ifFalse: [ 'session not present' ]);
		nextPut: $)
]

{ #category : #'initialize-release' }
MQTTConnectAcknowledgement >> readFrom: binaryStream [
	self assert: (super readFrom: binaryStream) = self remainingLength.
	self sessionPresent: binaryStream next = 1. 
	self returnCode: binaryStream next
]

{ #category : #accessing }
MQTTConnectAcknowledgement >> remainingLength [
	^ 2
]

{ #category : #accessing }
MQTTConnectAcknowledgement >> returnCode [
	^ returnCode
]

{ #category : #'initialize-release' }
MQTTConnectAcknowledgement >> returnCode: integer [
	returnCode := integer
]

{ #category : #accessing }
MQTTConnectAcknowledgement >> returnCodeMeaning [
	^ self class returnCodes 
		at: self returnCode + 1
		ifAbsent: [ 'Unknown return code [{1}]' format: { self returnCode } ]
]

{ #category : #accessing }
MQTTConnectAcknowledgement >> sessionPresent [
	^ sessionPresent
]

{ #category : #'initialize-release' }
MQTTConnectAcknowledgement >> sessionPresent: boolean [
	sessionPresent := boolean
]

{ #category : #accessing }
MQTTConnectAcknowledgement >> typeTag [
	^ #connack
]

{ #category : #accessing }
MQTTConnectAcknowledgement >> variableHeaderLength [
	^ 2
]

{ #category : #writing }
MQTTConnectAcknowledgement >> writeOn: binaryStream [
	super writeOn: binaryStream.
	binaryStream nextPut: self sessionPresent asBit.
	binaryStream nextPut: self returnCode 
]
