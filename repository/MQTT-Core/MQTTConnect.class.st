"
I am MQTTConnect.
I am an MQTTPacket.

I hold various parameters related to connection setup. I hold the client identification string (#clientId), the clean session flag (#cleanSession), the optional keep alive interval (#keepalive), the optional username (#username) and password (#password) as well as the optional will topic (#willTopic), message (#willMessage), quality of service (#willQoS) and retain flag (#willRetain).

After a Network Connection is established by a Client to a Server, the first Packet sent from the Client to the Server MUST be a CONNECT Packet.
 
A Client can only send the CONNECT Packet once over a Network Connection. The Server MUST process a second CONNECT Packet sent from a Client as a protocol violation and disconnect the Client.

The Client Identifier (ClientId) identifies the Client to the Server. Each Client connecting to the Server has a unique ClientId. The ClientId MUST be used by Clients and by Servers to identify state that they hold relating to this MQTT Session between the Client and the Server.

If CleanSession is set to 0, the Server MUST resume communications with the Client based on state from the current Session (as identified by the Client identifier). If there is no Session associated with the Client identifier the Server MUST create a new Session. The Client and Server MUST store the Session after the Client and Server are disconnected. After the disconnection of a Session that had CleanSession set to 0, the Server MUST store further QoS 1 and QoS 2 messages that match any subscriptions that the client had at the time of disconnection as part of the Session state. It MAY also store QoS 0 messages that meet the same criteria.
 
If CleanSession is set to 1, the Client and Server MUST discard any previous Session and start a new one. This Session lasts as long as the Network Connection. State data associated with this Session MUST NOT be reused in any subsequent Session.

If the Will Flag is set to 1 this indicates that, if the Connect request is accepted, a Will Message MUST be stored on the Server and associated with the Network Connection. The Will Message MUST be published when the Network Connection is subsequently closed unless the Will Message has been deleted by the Server on receipt of a DISCONNECT Packet.

A will message is sent to the will topic, using the will QoS and retain options.

The Keep Alive is a time interval measured in seconds. Expressed as a 16-bit word, it is the maximum time interval that is permitted to elapse between the point at which the Client finishes transmitting one Control Packet and the point it starts sending the next. It is the responsibility of the Client to ensure that the interval between Control Packets being sent does not exceed the Keep Alive value. In the absence of sending any other Control Packets, the Client MUST send a PINGREQ Packet.
 
The Client can send PINGREQ at any time, irrespective of the Keep Alive value, and use the PINGRESP to determine that the network and the Server are working.
 
If the Keep Alive value is non-zero and the Server does not receive a Control Packet from the Client within one and a half times the Keep Alive time period, it MUST disconnect the Network Connection to the Client as if the network had failed.
 
If a Client does not receive a PINGRESP Packet within a reasonable amount of time after it has sent a PINGREQ, it SHOULD close the Network Connection to the Server.
 
A Keep Alive value of zero (0) has the effect of turning off the keep alive mechanism. This means that, in this case, the Server is not required to disconnect the Client on the grounds of inactivity. Note that a Server is permitted to disconnect a Client that it determines to be inactive or non-responsive at any time, regardless of the Keep Alive value provided by that Client.

See also MQTTConnectAcknowledgement
"
Class {
	#name : #MQTTConnect,
	#superclass : #MQTTPacket,
	#instVars : [
		'cleanSession',
		'willTopic',
		'willMessage',
		'willQoS',
		'willRetain',
		'username',
		'password',
		'keepalive',
		'clientId'
	],
	#category : 'MQTT-Core'
}

{ #category : #comparing }
MQTTConnect >> = anObject [
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self class instVarNames allSatisfy: [ :each | 
		(self perform: each) = (anObject perform: each) ]
]

{ #category : #accessing }
MQTTConnect >> cleanSession [
	^ cleanSession
]

{ #category : #'initialize-release' }
MQTTConnect >> cleanSession: boolean [
	cleanSession := boolean 
]

{ #category : #accessing }
MQTTConnect >> clientId [
	^ clientId
]

{ #category : #'initialize-release' }
MQTTConnect >> clientId: string [
	clientId := string
]

{ #category : #accessing }
MQTTConnect >> connectFlags [
	| byte |
	byte := self willQoS << 3.
	byte := byte bitAt: 2 put: self cleanSession asBit.
	byte := byte bitAt: 3 put: self hasWill asBit.
	byte := byte bitAt: 6 put: self willRetain asBit.
	byte := byte bitAt: 7 put: self hasPassword asBit.
	byte := byte bitAt: 8 put: self hasUsername asBit.
	^ byte
]

{ #category : #testing }
MQTTConnect >> hasKeepalive [
	^ self keepalive isZero not
]

{ #category : #testing }
MQTTConnect >> hasPassword [
	^ self password notNil
]

{ #category : #testing }
MQTTConnect >> hasUsername [
	^ self username notNil
]

{ #category : #testing }
MQTTConnect >> hasWill [
	^ self willMessage notNil and: [ self willTopic notNil ]
]

{ #category : #comparing }
MQTTConnect >> hash [
	^ self class instVarNames 
		inject: 0 
		into: [ :acc :each | acc bitXor: (self perform: each) hash ]
]

{ #category : #'initialize-release' }
MQTTConnect >> initialize [
	super initialize.
	clientId := 'PharoMQTTClient' , 1e6 atRandom asString.
	cleanSession := true.
	willQoS := 0.
	willRetain := false.
	keepalive := 0

]

{ #category : #accessing }
MQTTConnect >> keepalive [
	^ keepalive
]

{ #category : #'initialize-release' }
MQTTConnect >> keepalive: seconds [
	self assert: (seconds between: 0 and: 16rFFFF).
	keepalive := seconds
]

{ #category : #accessing }
MQTTConnect >> password [
	^ password
]

{ #category : #'initialize-release' }
MQTTConnect >> password: bytes [
	password := bytes
]

{ #category : #accessing }
MQTTConnect >> payloadLength [
	| length |
	length := self encodedStringLength: self clientId.
	self hasWill
		ifTrue: [ 
			length := length 
								+ (self encodedStringLength: self willTopic) 
								+ (self encodedBytesLength: self willMessage) ].
	self hasUsername
		ifTrue: [ length := length + (self encodedStringLength: self username) ].
	self hasPassword
		ifTrue: [ length := length + (self encodedBytesLength: self password) ].
	^ length
]

{ #category : #printing }
MQTTConnect >> printOn: stream [
	super printOn: stream.
	stream
		nextPut: $(;
		nextPutAll: self clientId;
		nextPutAll: ' - ';
		nextPutAll:
				(self cleanSession
						ifTrue: [ 'clean session' ]
						ifFalse: [ 'resume session' ]);
		nextPut: $)
]

{ #category : #accessing }
MQTTConnect >> protocolLevel [
	^ 4
]

{ #category : #'initialize-release' }
MQTTConnect >> readFrom: binaryStream [
	| remainingLength connectFlags |
	remainingLength := super readFrom: binaryStream.
	self validateProtocolFrom: binaryStream.
	connectFlags := binaryStream next.
	self setFlagsFrom: connectFlags.
	self readPayloadFrom: binaryStream using: connectFlags.
	self assert: self remainingLength = remainingLength
]

{ #category : #private }
MQTTConnect >> readPayloadFrom: binaryStream using: connectFlags [
	self keepalive: (self readInt16From: binaryStream).
	self clientId: (self readStringFrom: binaryStream).
	(connectFlags bitAt: 3) = 1
		ifTrue: [ 
			self willTopic: (self readStringFrom: binaryStream).
			self willMessage: (self readBytesFrom: binaryStream) ].
	(connectFlags bitAt: 8) = 1
		ifTrue: [ self username: (self readStringFrom: binaryStream) ].
	(connectFlags bitAt: 7) = 1
		ifTrue: [ self password: (self readBytesFrom: binaryStream) ]
]

{ #category : #private }
MQTTConnect >> setFlagsFrom: connectFlags [
	self willQoS: (connectFlags bitAnd: 2r11000) >> 3.
	self cleanSession: (connectFlags bitAt: 2) = 1.
	self willRetain: (connectFlags bitAt: 6) = 1
]

{ #category : #accessing }
MQTTConnect >> typeTag [
	^ #connect
]

{ #category : #accessing }
MQTTConnect >> username [
	^ username
]

{ #category : #'initialize-release' }
MQTTConnect >> username: string [
	username := string
]

{ #category : #private }
MQTTConnect >> validateProtocolFrom: binaryStream [
	self assert: (self readStringFrom: binaryStream) = 'MQTT'.
	self assert: binaryStream next = self protocolLevel
]

{ #category : #accessing }
MQTTConnect >> variableHeaderLength [
	^ 10
]

{ #category : #accessing }
MQTTConnect >> willMessage [
	^ willMessage 
]

{ #category : #'initialize-release' }
MQTTConnect >> willMessage: bytes [
	willMessage := bytes
]

{ #category : #accessing }
MQTTConnect >> willQoS [
	^ willQoS 
]

{ #category : #'initialize-release' }
MQTTConnect >> willQoS: integer [
	self assert: (self class qualityOfServiceLevels includes: integer).
	willQoS := integer
]

{ #category : #accessing }
MQTTConnect >> willRetain [
	^ willRetain
]

{ #category : #'initialize-release' }
MQTTConnect >> willRetain: boolean [
	willRetain := boolean
]

{ #category : #accessing }
MQTTConnect >> willTopic [
	^ willTopic 
]

{ #category : #'initialize-release' }
MQTTConnect >> willTopic: string [
	willTopic := string
]

{ #category : #writing }
MQTTConnect >> writeOn: binaryStream [
	super writeOn: binaryStream.
	self writeVariableHeaderOn: binaryStream.
	self writePayloadOn: binaryStream 
]

{ #category : #writing }
MQTTConnect >> writePayloadOn: binaryStream [
	self writeString: self clientId on: binaryStream.
	self hasWill
		ifTrue: [ 
			self writeString: self willTopic on: binaryStream.
			self writeBytes: self willMessage on: binaryStream ].
	self hasUsername
		ifTrue: [ self writeString: self username on: binaryStream ].
	self hasPassword
		ifTrue: [ self writeBytes: self password on: binaryStream ]
]

{ #category : #writing }
MQTTConnect >> writeVariableHeaderOn: binaryStream [
	self writeString: 'MQTT' on: binaryStream.
	binaryStream nextPut: self protocolLevel.
	binaryStream nextPut: self connectFlags.
	self writeInt16: self keepalive on: binaryStream 
]
