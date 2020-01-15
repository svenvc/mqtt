"
I am MQTTPrimitiveClient.
I am an MQTTAbstractClient.

I am a straightforward implementation of a simple MQTT client.

I do not handle keep alive.

See MQTTClient for a more robust implementation.

Implementation note:

We assume here that responses are synchroneous: i.e. there are no intervening messages of different types. This is most probably wrong, but on all tested servers so far this seems to work out fine, for simple interactions. This might no longer be the case when listening to a busy topic.
"
Class {
	#name : #MQTTPrimitiveClient,
	#superclass : #MQTTAbstractClient,
	#category : #'MQTT-Client'
}

{ #category : #'initialize-release' }
MQTTPrimitiveClient >> close [
	connection
		ifNotNil: [ 
			[ self writePacket: MQTTDisconnect new.
			 connection close ] on: Error do: [ ].
			connection := nil ].
	self subscriptions removeAll.
	^ true
]

{ #category : #private }
MQTTPrimitiveClient >> connectionClass [
	^ self useTLS 
			ifTrue: [ ZdcSecureSocketStream ] 
			ifFalse: [ ZdcSocketStream ]
]

{ #category : #accessing }
MQTTPrimitiveClient >> newConnectPacket [
	^ MQTTConnect new
		clientId: self clientId;
		username: self username;
		password: self password;
		keepalive: self keepalive;
		cleanSession: self cleanSession;
		yourself
]

{ #category : #accessing }
MQTTPrimitiveClient >> newPublishPacketToTopic: topicString [
	| publish |
	publish := MQTTPublish new.
	publish topic: topicString.
	publish qualityOfService: self qualityOfService.
	publish isIdRequired ifTrue: [ publish id: self nextId ].
	^ publish

]

{ #category : #'initialize-release' }
MQTTPrimitiveClient >> open [
	| packet |
	self close.
	self openConnection.
	self writePacket: self newConnectPacket.
	packet := self readPacket.
	self assert: packet isAccepted.
	^ packet
]

{ #category : #private }
MQTTPrimitiveClient >> openConnection [
	| address |
	address := NetNameResolver addressForName: self host timeout: self timeout.
	connection := self connectionClass
		openConnectionToHost: address
		port: self port
		timeout: self timeout.
	self useTLS ifTrue:	[ connection connect ]
]

{ #category : #public }
MQTTPrimitiveClient >> ping [
	"Send a ping request and wait for a ping reply."
	
	| ping packet |
	ping := MQTTPingRequest new.
	self writePacket: ping.
	packet := self readPacket.
	self assert: packet = ping response.
	^ true
]

{ #category : #public }
MQTTPrimitiveClient >> readMessage [
	"Read a message while handling the necessary QoS flows.
	Might fail with ConnectionTimedOut."
	
	| packet |
	packet := self readPacket.
	"Handle normal responses (PUBACK, PINGRESP)"
	packet response ifNotNil: [ :response |
		self writePacket: response.
		"Handle QoS=2 second phase"
		response response ifNotNil: [ :response2 | | packet2 |
			"1. packet=PUBLISH (in) 2. response=PUBREC (out) 
			3. response2=PUBREL=packet2 (in) 4. finally send PUBCOMP (out)"
			packet2 := self readPacket.
			self assert: packet2 = response2.
			self writePacket: packet2 response ] ].
	^ packet
]

{ #category : #public }
MQTTPrimitiveClient >> sendMessage: bytes toTopic: topicString [
	"Send a message consisting of bytes to topicString while handling QoS flows.
	Might fail with ConnectionTimedOut."
	
	| publish packet |
	publish := self newPublishPacketToTopic: topicString.
	publish message: bytes.
	self writePacket: publish.
	"Handle normal responses (PUBACK)"
	publish response ifNotNil: [ :response |
		packet := self readPacket.
		self assert: packet = response.
		"Handle QoS=2 second phase"
		response response ifNotNil: [ :response2 | | packet2 |
			"1. publish=PUBLISH (out) 2. response=PUBREC=packet (in) 
			3. response2=PUBREL (out) 4. finally read PUBCOMP (in)"
			self writePacket: response2.
			packet2 := self readPacket.
			self assert: packet2 = response2 response ] ].
	^ true
]

{ #category : #public }
MQTTPrimitiveClient >> subscribeToTopic: topicFilter [
	"Subscribe to topicFilter at my default QoS.
	The server/broker will send us messages matching topicFilter."
	
	^ self subscribeToTopic: topicFilter qos: self qualityOfService 
]

{ #category : #public }
MQTTPrimitiveClient >> subscribeToTopic: topicFilter qos: qos [
	"Subscribe to topicFilter at qos.
	The server/broker will send us messages matching topicFilter."
	
	| subscribe packet |
	subscribe := MQTTSubscribe new.
	subscribe id: self nextId.
	subscribe addTopicFilter: topicFilter withQoS: qos.
	self writePacket: subscribe.
	packet := self readPacket.
	self assert: packet = subscribe response.
	self subscriptions add: topicFilter.
	^ true
]

{ #category : #public }
MQTTPrimitiveClient >> unsubscribeFromTopic: topicFilter [
	"Unsubscribe frin topicFilter.
	The server/broker will no longer send us messages matching topicFilter."

	| unsubscribe packet |
	unsubscribe := MQTTUnsubscribe new.
	unsubscribe id: self nextId.
	unsubscribe addTopicFilter: topicFilter.
	self writePacket: unsubscribe.
	packet := self readPacket.
	self assert: packet = unsubscribe response.
	self subscriptions remove: topicFilter ifAbsent: [].
	^ true
]
