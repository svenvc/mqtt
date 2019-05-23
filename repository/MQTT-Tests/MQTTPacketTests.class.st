"
Units test for MQTT Packets.
"
Class {
	#name : #MQTTPacketTests,
	#superclass : #TestCase,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTPacketTests >> testConnectAcknowledgementCustom [
	| packet bytes readPacket |
	packet := MQTTConnectAcknowledgement new.
	packet returnCode: 5.
	packet sessionPresent: true.
	self assert: packet returnCode equals: 5.
	self assert: packet sessionPresent.
	self deny: packet isAccepted.
	bytes := packet asByteArray.
	self assert: bytes equals: #[32 2 1 5].
	readPacket := MQTTIdPacket fromByteArray: #[32 2 1 5].
	self assert: readPacket returnCode equals: 5.
	self assert: readPacket sessionPresent.
	self deny: readPacket isAccepted.
	self assert: readPacket equals: packet
]

{ #category : #testing }
MQTTPacketTests >> testConnectAcknowledgementDefault [
	| packet bytes |
	packet := MQTTConnectAcknowledgement new.
	self deny: packet sessionPresent.
	self assert: packet isAccepted.
	bytes := packet asByteArray.
	self assert: bytes equals: #[32 2 0 0].
	packet := MQTTIdPacket fromByteArray: #[32 2 0 0].
	self deny: packet sessionPresent.
	self assert: packet isAccepted.
	self assert: packet equals: MQTTConnectAcknowledgement new
]

{ #category : #testing }
MQTTPacketTests >> testConnectDefault [
	| packet bytes |
	packet := MQTTConnect new.
	packet clientId: 'id'.
	self assert: packet cleanSession.
	self assert: packet clientId equals: 'id'.
	self deny: packet hasWill.
	self assert: packet willQoS isZero.
	self deny: packet willRetain.
	self deny: packet hasUsername.
	self deny: packet hasPassword.
	self deny: packet hasKeepalive.
	bytes :=  packet asByteArray.
	self assert: bytes equals: #[16 14 0 4 77 81 84 84 4 2 0 0 0 2 105 100].
	packet := MQTTPacket fromByteArray: #[16 14 0 4 77 81 84 84 4 2 0 0 0 2 105 100].
	self assert: packet cleanSession.
	self assert: packet clientId equals: 'id'.
	self deny: packet hasWill.
	self assert: packet willQoS isZero.
	self deny: packet willRetain.
	self deny: packet hasUsername.
	self deny: packet hasPassword.
	self deny: packet hasKeepalive.
	self assert: packet equals: (MQTTConnect new clientId: 'id'; yourself)
	
]

{ #category : #testing }
MQTTPacketTests >> testConnectDefaultCustom [
	| connect bytes packet |
	connect := MQTTConnect new.
	connect clientId: 'id'.
	connect cleanSession: false.
	connect username: 'user'.
	connect password: 'secret' asByteArray.
	connect keepalive: 10.
	connect willTopic: 'will'.
	connect willMessage: 'will' asByteArray.
	connect willQoS: 1.
	connect willRetain: true.
	self deny: connect cleanSession.
	self assert: connect clientId equals: 'id'.
	self assert: connect hasKeepalive.
	self assert: connect keepalive equals: 10.
	self assert: connect hasUsername.
	self assert: connect hasPassword.
	self assert: connect username equals: 'user'.
	self assert: connect password equals: 'secret' asByteArray.
	self assert: connect hasWill.
	self assert: connect willRetain.
	self assert: connect willTopic equals: 'will'.
	self assert: connect willMessage equals: 'will' asByteArray.
	self assert: connect willQoS equals: 1.
	bytes := connect asByteArray.
	packet := MQTTPacket fromByteArray: bytes.
	self deny: packet cleanSession.
	self assert: packet clientId equals: 'id'.
	self assert: packet hasKeepalive.
	self assert: packet keepalive equals: 10.
	self assert: packet hasUsername.
	self assert: packet hasPassword.
	self assert: packet username equals: 'user'.
	self assert: packet password equals: 'secret' asByteArray.
	self assert: packet hasWill.
	self assert: packet willRetain.
	self assert: packet willTopic equals: 'will'.
	self assert: packet willMessage equals: 'will' asByteArray.
	self assert: packet willQoS equals: 1.
	self assert: packet equals: connect
	
]

{ #category : #testing }
MQTTPacketTests >> testDisconnect [
	| packet bytes |
	packet := MQTTDisconnect new.
	bytes := packet asByteArray.
	self assert: bytes equals: #[224 0].
	packet := MQTTPacket fromByteArray: #[224 0].
	self assert: packet equals: MQTTDisconnect new
]

{ #category : #testing }
MQTTPacketTests >> testPing [
	| packet bytes |
	packet := MQTTPingRequest new.
	bytes := packet asByteArray.
	self assert: bytes equals: #[192 0].
	packet := MQTTPacket fromByteArray: #[192 0].
	self assert: packet equals: MQTTPingRequest new.
	
	packet := MQTTPingResponse new.
	bytes := packet asByteArray.
	self assert: bytes equals: #[208 0].
	packet := MQTTPacket fromByteArray: #[208 0].
	self assert: packet equals: MQTTPingResponse new.
]

{ #category : #testing }
MQTTPacketTests >> testPublish0 [
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet topic: 'ab'.
	packet message: 'message' asByteArray.
	self deny: packet hasId.
	self deny: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket atMostOnce.
	self assert: packet topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self deny: readPacket hasId.
	self deny: readPacket isIdRequired.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self assert: packet hasMessage.
	self assert: readPacket qualityOfService equals: MQTTPacket atMostOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	self assert: readPacket equals: packet

]

{ #category : #testing }
MQTTPacketTests >> testPublish0Empty [
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet topic: 'ab'.
	self deny: packet hasId.
	self deny: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self deny: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket atMostOnce.
	self assert: packet topic equals: 'ab'.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self deny: readPacket hasId.
	self deny: readPacket isIdRequired.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self deny: readPacket hasMessage.
	self assert: readPacket qualityOfService equals: MQTTPacket atMostOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: readPacket equals: packet

]

{ #category : #testing }
MQTTPacketTests >> testPublish1 [
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet id: 321.
	packet topic: 'ab'.
	packet message: 'message' asByteArray.
	packet qualityOfService: MQTTPacket atLeastOnce.
	self assert: packet hasId.
	self assert: packet id equals: 321.
	self assert: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket atLeastOnce.
	self assert: packet topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: packet hasId.
	self assert: packet id equals: 321.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket atLeastOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	self assert: readPacket equals: packet
]

{ #category : #testing }
MQTTPacketTests >> testPublish2 [
	| packet bytes readPacket |
	packet := MQTTPublish new.
	packet id: 321.
	packet topic: 'ab'.
	packet message: 'message' asByteArray.
	packet qualityOfService: MQTTPacket exactlyOnce.
	self assert: packet hasId.
	self assert: packet id equals: 321.
	self assert: packet isIdRequired.
	self deny: packet duplicate.
	self deny: packet retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket exactlyOnce.
	self assert: packet topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: packet hasId.
	self assert: packet id equals: 321.
	self deny: readPacket duplicate.
	self deny: readPacket retain.
	self assert: packet hasMessage.
	self assert: packet qualityOfService equals: MQTTPacket exactlyOnce.
	self assert: readPacket topic equals: 'ab'.
	self assert: packet message equals: 'message' asByteArray.
	self assert: readPacket equals: packet
]

{ #category : #testing }
MQTTPacketTests >> testPublishAcknowledgement [
	| packet bytes |
	packet := MQTTPublishAcknowledgement new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[64 2 1 65].
	packet := MQTTPacket fromByteArray: #[64 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishAcknowledgement new id: 321; yourself)
]

{ #category : #testing }
MQTTPacketTests >> testPublishComplete [
	| packet bytes |
	packet := MQTTPublishComplete new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[112 2 1 65].
	packet := MQTTPacket fromByteArray: #[112 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishComplete new id: 321; yourself)
]

{ #category : #testing }
MQTTPacketTests >> testPublishReceived [
	| packet bytes |
	packet := MQTTPublishReceived new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[80 2 1 65].
	packet := MQTTPacket fromByteArray: #[80 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishReceived new id: 321; yourself)
]

{ #category : #testing }
MQTTPacketTests >> testPublishRelease [
	| packet bytes |
	packet := MQTTPublishRelease new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[98 2 1 65].
	packet := MQTTPacket fromByteArray: #[98 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTPublishRelease new id: 321; yourself)
]

{ #category : #testing }
MQTTPacketTests >> testSubscribe [
	| packet bytes readPacket |
	packet := MQTTSubscribe new.
	packet id: 321.
	packet addTopicFilter: 'ab' withQoS: MQTTPacket atMostOnce.
	packet addTopicFilter: 'cd' withQoS: MQTTIdPacket atLeastOnce.
	packet addTopicFilter: 'ef' withQoS: MQTTIdPacket exactlyOnce.
	self assert: packet id equals: 321.
	self assert: packet topics equals: #(ab cd ef) asOrderedCollection.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: readPacket id equals: 321.
	self assert: readPacket equals: packet.
	self assert: readPacket topics equals: #(ab cd ef) asOrderedCollection 

]

{ #category : #testing }
MQTTPacketTests >> testSubscribeAcknowledgement [
	| packet bytes readPacket |
	packet := MQTTSubscribeAcknowledgement new.
	packet id: 321.
	packet addReturnCode: MQTTPacket atMostOnce.
	packet addReturnCode: MQTTPacket atLeastOnce.
	packet addReturnCode: MQTTIdPacket exactlyOnce.
	packet addReturnCode: MQTTSubscribeAcknowledgement failure.
	self assert: packet id equals: 321.
	self assert: packet returnCodes equals: { MQTTPacket atMostOnce. MQTTPacket atLeastOnce. MQTTIdPacket exactlyOnce. MQTTSubscribeAcknowledgement failure } asOrderedCollection.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: readPacket id equals: 321.
	self assert: readPacket equals: packet.
	self assert: readPacket returnCodes equals: { MQTTPacket atMostOnce. MQTTPacket atLeastOnce. MQTTIdPacket exactlyOnce. MQTTSubscribeAcknowledgement failure } asOrderedCollection.

]

{ #category : #testing }
MQTTPacketTests >> testUnsubscribe [
	| packet bytes readPacket |
	packet := MQTTUnsubscribe new.
	packet id: 321.
	packet addTopicFilter: 'ab'.
	packet addTopicFilter: 'cd'.
	packet addTopicFilter: 'ef'.
	self assert: packet id equals: 321.
	self assert: packet topics equals: #(ab cd ef) asOrderedCollection.
	bytes := packet asByteArray.
	readPacket := MQTTPacket fromByteArray: bytes.
	self assert: readPacket id equals: 321.
	self assert: readPacket equals: packet.
	self assert: readPacket topics equals: #(ab cd ef) asOrderedCollection 

]

{ #category : #testing }
MQTTPacketTests >> testUnsubscribeAcknowledgement [
	| packet bytes |
	packet := MQTTUnsubscribeAcknownledgement new.
	packet id: 321.
	self assert: packet id equals: 321.
	bytes := packet asByteArray.
	self assert: bytes equals: #[176 2 1 65].
	packet := MQTTPacket fromByteArray: #[176 2 1 65].
	self assert: packet id equals: 321.
	self assert: packet equals: (MQTTUnsubscribeAcknownledgement new id: 321; yourself)
]
