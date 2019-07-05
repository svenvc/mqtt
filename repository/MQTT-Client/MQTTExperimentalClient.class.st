"
I am MQTTExperimentalClient.
I am an MQTTPrimitiveClient and a MQTTAbstractClient.

I am an experimental / proof of concept implementation of a simple MQTT client.

Examples:

Send a single message to a topic to the local broker, say a temperature reading of a sensor, using QoS level 1.

  MQTTExperimentalClient new
    atLeastOnce;
    open;
    sendMessage: 20 asByteArray toTopic: '/device/42/outside-temperature';
    close.

Same message to a remote host, using the default QoS level 0.

  MQTTExperimentalClient new
    host: 'iot.example.com';
    open;
    sendMessage: 21 asByteArray toTopic: '/device/42/outside-temperature';
    close.

Read a single message, using QoS level 2 (client should be closed afterwards)

  MQTTExperimentalClient new
    exactlyOnce;
    open;
    subscribeToTopic: '/new-user-notifications';
    readMessage.

Read and collect 10 temperature readings 

  Array streamContents: [ :stream | | count |
    count := 1.
    MQTTExperimentalClient new
       open;
       subscribeToTopic: '/device/42/outside-temperature';
       runWith: [ :message |
         stream nextPut: message contents asInteger.
         (count := count + 1) > 10 ifTrue: [ ConnectionClosed signal ] ] ].

Collect 100 system notifications

  Array streamContents: [ :stream | | count |
    count := 1.
    MQTTExperimentalClient new
      host: 'iot.eclipse.org';
      open;
      subscribeToTopic: '$SYS/#';
      runWith: [ :message |
        stream nextPut: message.
        (count := count + 1) > 100 ifTrue: [ ConnectionClosed signal ] ] ].

Implementation note:

I use an inbox when reading messages so that I can store unexpected out of band messages. 
Reading a message requires a condition filter.
I handle keepalive and ping.
I implement #runWith: to program in event driven style.
"
Class {
	#name : #MQTTExperimentalClient,
	#superclass : #MQTTPrimitiveClient,
	#instVars : [
		'inbox',
		'lastActivity'
	],
	#category : 'MQTT-Client'
}

{ #category : #'initialize-release' }
MQTTExperimentalClient >> clearInbox [
	inbox removeAll
]

{ #category : #'initialize-release' }
MQTTExperimentalClient >> close [
	super close.
	self clearInbox.
	^ true
]

{ #category : #private }
MQTTExperimentalClient >> enforceKeepaliveTimoutRelation [
	self assert: (self keepalive isZero or: [ self timeout <= self keepalive ])
]

{ #category : #private }
MQTTExperimentalClient >> failedToReadInTimeout [
	^ ConnectionTimedOut signal: 'Could not read matching packet before timeout'
]

{ #category : #'initialize-release' }
MQTTExperimentalClient >> initialize [
	super initialize.
	inbox := OrderedCollection new
]

{ #category : #'initialize-release' }
MQTTExperimentalClient >> keepalive: seconds [
	super keepalive: seconds.
	self enforceKeepaliveTimoutRelation
]

{ #category : #accessing }
MQTTExperimentalClient >> lastActivity [
	^ lastActivity ifNil: [ self touch ]
]

{ #category : #public }
MQTTExperimentalClient >> ping [
	"Send a ping request and wait for a ping reply."
	
	| ping expectedResponse |
	ping := MQTTPingRequest new.
	self writePacket: ping.
	expectedResponse := ping response.
	self readSuchThat: [ :packet | packet = expectedResponse ].
	^ true
]

{ #category : #private }
MQTTExperimentalClient >> pingIfNeeded [
	self keepalive isZero
		ifTrue: [ ^ self ].
	(Time millisecondsSince: self lastActivity) / 1000 > self keepalive
		ifTrue: [ ^ self ping ]
]

{ #category : #'input/output' }
MQTTExperimentalClient >> readFromInboxSuchThat: block [
	| packet |
	packet := inbox detect: block ifNone: [ ^ nil ].
	inbox remove: packet.
	^ packet
]

{ #category : #public }
MQTTExperimentalClient >> readMessage [
	"Read a message while handling the necessary QoS flows.
	Only application messages with an actual payload will be returned.
	Might fail with ConnectionTimedOut."

	^ self readSuchThat: [ :packet | packet isApplicationMessage ]
]

{ #category : #'input/output' }
MQTTExperimentalClient >> readPacketWithQoSFlow [
	| packet |
	packet := self readPacket.
	"Handle normal first phase responses (PUBACK, PINGRESP)"
	packet response ifNotNil: [ :expectedResponse |
		self writePacket: expectedResponse.
		"Handle QoS=2 second phase"
		expectedResponse response ifNotNil: [ :expectedResponse2 |
			"1. packet=PUBLISH (in) 2. response=PUBREC (out) 
			3. response2=PUBREL=packet2 (in) 4. finally send PUBCOMP (out)"
			"recursive call, final write happens there as well"
			self readSuchThat: [ :packetRead | packetRead = expectedResponse2 ] ] ].
	^ packet
]

{ #category : #public }
MQTTExperimentalClient >> readSuchThat: block [
	"Read a message while handling the necessary QoS flows.
	Only application messages for which block evaluates to true will be returned.
	Might fail with ConnectionTimedOut."

	| packet started |
	self pingIfNeeded.
	started := Time millisecondClockValue.
	[
		(self readFromInboxSuchThat: block) 
			ifNotNil: [ :found | ^ found ].
		packet := self readPacketWithQoSFlow.
		(block value: packet)
			ifTrue: [ ^ packet ]
			ifFalse: [ inbox add: packet ].
		(Time millisecondsSince: started) / 1000 > self timeout
			ifTrue: [ ^ self failedToReadInTimeout ] ] repeat
]

{ #category : #public }
MQTTExperimentalClient >> runWith: block [
	"Enter a loop reading messages, ignoring ConnectionTimedOut.
	Block is evaluated for each incoming message.
	When the loop ends, the receiver is #close-ed.
	ConnectionClosed can be signalled to exit the loop"
	
	[ [ [ 
		[ block value: self readMessage ]
			on: ConnectionTimedOut  
			do: [ "self log: 'Connection timed out, continuing loop'" ] 
	] repeat
	] ensure: [ self close ]
	] on: ConnectionClosed do: [ self log: 'Connection closed, ending loop' ]
]

{ #category : #public }
MQTTExperimentalClient >> sendMessage: bytes toTopic: topicString [
	"Send a message consisting of bytes to topicString while handling QoS flows.
	Might fail with ConnectionTimedOut."

	| publish |
	publish := self newPublishPacketToTopic: topicString.
	publish message: bytes.
	self writePacket: publish.
	"QoS=1 normal responses (PUBACK)"
	publish response ifNotNil: [ :expectedResponse1 |
		"QoS=2 second phase will be handled in #readSuchThat:"
		self readSuchThat: [ :packet | packet = expectedResponse1 ] ].
	^ true
]

{ #category : #public }
MQTTExperimentalClient >> subscribeToTopic: topicFilter qos: qos [
	"Subscribe to topicFilter at qos.
	The server/broker will send us messages matching topicFilter."

	| subscribe expectedResponse |
	subscribe := MQTTSubscribe new.
	subscribe id: self nextId.
	subscribe addTopicFilter: topicFilter withQoS: qos.
	self writePacket: subscribe.
	expectedResponse := subscribe response.
	self readSuchThat: [ :packet | packet = expectedResponse ].
	self subscriptions add: topicFilter.
	^ true
]

{ #category : #'initialize-release' }
MQTTExperimentalClient >> timeout: seconds [
	super timeout: seconds.
	self enforceKeepaliveTimoutRelation
]

{ #category : #private }
MQTTExperimentalClient >> touch [
	lastActivity := Time millisecondClockValue 
]

{ #category : #public }
MQTTExperimentalClient >> unsubscribeFromTopic: topicFilter [
	"Unsubscribe frin topicFilter.
	The server/broker will no longer send us messages matching topicFilter."

	| unsubscribe expectedResponse |
	unsubscribe := MQTTUnsubscribe new.
	unsubscribe id: self nextId.
	unsubscribe addTopicFilter: topicFilter.
	self writePacket: unsubscribe.
	expectedResponse := unsubscribe response.
	self readSuchThat: [ :packet | packet = expectedResponse ].
	self subscriptions remove: topicFilter.
	^ true
]

{ #category : #'input/output' }
MQTTExperimentalClient >> writePacket: packet [
	super writePacket: packet.
	self touch
]

{ #category : #'input/output' }
MQTTExperimentalClient >> writePacketWithQoSFlow: packet [
	self writePacket: packet.
	"QoS=1 normal responses (PUBACK)"
	packet response ifNotNil: [ :expectedResponse1 |
		"QoS=2 second phase will be handled in #readSuchThat:"
		self readSuchThat: [ :packetRead | packetRead = expectedResponse1 ] ]
]
