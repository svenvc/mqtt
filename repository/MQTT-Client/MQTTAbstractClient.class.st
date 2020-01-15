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
		'cleanSession',
		'connection',
		'subscriptions',
		'idCounter',
		'useTLS'
	],
	#category : #'MQTT-Client'
}

{ #category : #accessing }
MQTTAbstractClient class >> url: anUrl [

	^ self new url: anUrl 
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> atLeastOnce [
	self qualityOfService: MQTTPacket atLeastOnce 
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> atMostOnce [
	self qualityOfService: MQTTPacket atMostOnce 
]

{ #category : #accessing }
MQTTAbstractClient >> cleanSession [
	^ cleanSession ifNil: [ cleanSession := true ]
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> cleanSession: boolean [
	cleanSession := boolean
]

{ #category : #accessing }
MQTTAbstractClient >> clientId [
	^ clientId ifNil: [ clientId := self class name asString , 1e6 atRandom asString. ]
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
	^ port ifNil: [ port := self useTLS ifTrue: [ 8883 ] ifFalse: [ 1883 ] ]
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
MQTTAbstractClient >> scheme [
	^ self useTLS ifTrue: [ #mqtts ] ifFalse: [ #mqtt ]
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
MQTTAbstractClient >> url [
	"Return my connection URL"
	
	^ ZnUrl new
		scheme: self scheme;
		host: self host;
		port: self port;
		username: self username;
		password: self password;
		addPathSegments: #(); "I do not hold a fixed topic"
		yourself
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> url: stringOrUrl [
	"Set my connection settings from stringOrUrl according to the format
	mqtt(s)://[username[:password]@]host[:port]/topic 
	For now, topic is not yet supported. Return my URL as interpreted."
	
	| url |
	url := stringOrUrl asUrl.
	self assert: (#(mqtt mqtts) includes: url scheme).
	^ self
		host: url host;
		port: (url portIfAbsent: [ nil ]);
		username: url username;
		password: url password;
		useTLS: url scheme = #mqtts;
		url
]

{ #category : #testing }
MQTTAbstractClient >> useTLS [
	"Return true if I use TLS (transport layer security) for mqtts,
	return false if I use plain connections for mqtt (the default)"
	
	^ useTLS ifNil: [ useTLS := false ]
]

{ #category : #'initialize-release' }
MQTTAbstractClient >> useTLS: boolean [
	"Set if I use TLS (transport layer security) for mqtts (true),
	or if I use plain connections for mqtt (false)"
	
	useTLS := boolean
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
