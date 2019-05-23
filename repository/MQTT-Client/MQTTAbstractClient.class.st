"
I am MQTTAbstractClient.

I hold data common to all clients, independent of how they work.
"
Class {
	#name : #MQTTAbstractClient,
	#superclass : #Object,
	#instVars : [
		'clientId',
		'host',
		'port',
		'username',
		'password',
		'timeout',
		'keepalive',
		'qualityOfService',
		'connection',
		'subscriptions',
		'idCounter'
	],
	#category : 'MQTT-Client'
}

{ #category : #'initialize-release' }
MQTTAbstractClient >> atLeastOnce [
	self qualityOfService: MQTTPacket atLeastOnce 
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> atMostOnce [
	self qualityOfService: MQTTPacket atMostOnce 
]

{ #category : #accessing }
MQTTAbstractClient >> clientId [
	^ clientId ifNil: [ clientId := self class name asString ]
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> clientId: string [
	clientId := string
]

{ #category : #accessing }
MQTTAbstractClient >> debug [
	^ true
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> exactlyOnce [
	self qualityOfService: MQTTPacket exactlyOnce 
]

{ #category : #accessing }
MQTTAbstractClient >> host [
	^ host ifNil: [ host := 'localhost' ]
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> host: anObject [
	host := anObject
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> initialize [
	super initialize.
	idCounter := 0.
	timeout := 5.
	keepalive := 0.
	qualityOfService := 0
]

{ #category : #testing }
MQTTAbstractClient >> isConnected [
	^ connection notNil
]

{ #category : #accessing }
MQTTAbstractClient >> keepalive [
	^ keepalive
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> keepalive: seconds [
	keepalive := seconds
]

{ #category : #'input/output' }
MQTTAbstractClient >> log: anObject [
	| line |
	self debug ifFalse: [ ^ self ].
	line := String streamContents: [ :out |
		DateAndTime now printOn: out.
		out << ' [ ' << self clientId << ' ]'.
		out << ' - '.
		out << anObject value ].
	self crLog: line
]

{ #category : #accessing }
MQTTAbstractClient >> nextId [
	^ idCounter := idCounter + 1
]

{ #category : #accessing }
MQTTAbstractClient >> password [
	^ password
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> password: bytes [
	password := bytes
]

{ #category : #accessing }
MQTTAbstractClient >> port [
	^ port ifNil: [ port := 1883 ]
]

{ #category : #accessing }
MQTTAbstractClient >> port: anObject [
	port := anObject
]

{ #category : #accessing }
MQTTAbstractClient >> qualityOfService [
	^ qualityOfService
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> qualityOfService: integer [
	qualityOfService := integer
]

{ #category : #'input/output' }
MQTTAbstractClient >> readPacket [
	| packet |
	packet := MQTTPacket readFrom: connection.
	self log: [ 'Read ', packet printString ].
	^ packet
]

{ #category : #accessing }
MQTTAbstractClient >> subscriptions [
	^ subscriptions ifNil: [ subscriptions := OrderedCollection new ]
]

{ #category : #accessing }
MQTTAbstractClient >> timeout [
	^ timeout
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> timeout: seconds [
	timeout := seconds
]

{ #category : #accessing }
MQTTAbstractClient >> username [
	^ username
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> username: string [
	username := string
]

{ #category : #'input/output' }
MQTTAbstractClient >> writePacket: packet [
	packet writeOn: connection.
	connection flush.
	self log: [ 'Wrote ', packet printString ]
]
