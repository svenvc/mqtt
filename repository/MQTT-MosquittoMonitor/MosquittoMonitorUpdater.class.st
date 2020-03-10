"
I am MosquittoMonitorUpdater.
"
Class {
	#name : #MosquittoMonitorUpdater,
	#superclass : #Object,
	#instVars : [
		'webSocket',
		'running',
		'info',
		'mqttClient'
	],
	#category : #'MQTT-MosquittoMonitor'
}

{ #category : #accessing }
MosquittoMonitorUpdater class >> keysAndFormatters [
	^ #(
	('version' string)
	('uptime' uptime)
	('bytes/received' integer)
	('bytes/sent' integer)
	('messages/received' integer)
	('messages/sent' integer)
	('messages/stored' integer)
	('retained messages/count' integer)
	('publish/bytes/received' integer)
	('publish/bytes/sent' integer)
	('publish/messages/received' integer)
	('publish/messages/sent' integer)
	('publish/messages/dropped' integer)
	('subscriptions/count' integer)
	('heap/current' integer)
	('heap/maximum' integer)
	('load/bytes/received' load)
	('load/bytes/sent' load)
	('load/messages/received' load)
	('load/messages/sent' load)
	('load/publish/received' load)
	('load/publish/sent' load)
	('load/publish/dropped' load)
	('load/connections' load)
	('load/sockets' load)
	('clients/total' integer)
	('clients/maximum' integer)
	('clients/active' integer)
	('clients/connected' integer)
	('clients/disconnected' integer)
	('clients/expired' integer)
	('clients/inactive' integer)
	)
]

{ #category : #private }
MosquittoMonitorUpdater >> cleanup [
	self running: false
]

{ #category : #private }
MosquittoMonitorUpdater >> forkMqttListener [
	[ self mqttClient 
			runWith: [ :message | | key value |
				key := message topic allButFirst: 12.
				value := message contents asString.
				info at: key put: value.
				self running ifFalse: [ ConnectionClosed signal ] ].
		self mqttClient close ]
			forkAt: Processor lowIOPriority
			named: 'mosquitto-monitor'
]

{ #category : #private }
MosquittoMonitorUpdater >> formatInteger: key [
	^ info 
		at: key 
		ifPresent: [ :str | str asInteger asStringWithCommas ] 
		ifAbsent: ''
]

{ #category : #private }
MosquittoMonitorUpdater >> formatLoad: key [
	| load1m load5m load15m |
	load1m := info at: key , '/1min' ifPresent: [ :str | str asNumber ] ifAbsent: 0.0.
	load5m := info at: key , '/5min' ifPresent: [ :str | str asNumber ] ifAbsent: 0.0.
	load15m := info at: key , '/15min' ifPresent: [ :str | str asNumber ] ifAbsent: 0.0.
	^ '{1} {2} {3}' format: { 
		load1m printShowingDecimalPlaces: 2. 
		load5m printShowingDecimalPlaces: 2. 
		load15m printShowingDecimalPlaces: 2 }
]

{ #category : #private }
MosquittoMonitorUpdater >> formatString: key [
	^ info 
		at: key 
		ifAbsent: ''
]

{ #category : #private }
MosquittoMonitorUpdater >> formatUptime: key [
	^ info 
		at: key 
		ifPresent: [ :str | 
			((str findTokens: ' ') first asInteger seconds roundTo: 1 minute) humanReadablePrintString ] 
		ifAbsent: ''
]

{ #category : #accessing }
MosquittoMonitorUpdater >> info [
	^ info
]

{ #category : #initialization }
MosquittoMonitorUpdater >> initialize [
	super initialize.
	info := Dictionary new
]

{ #category : #accessing }
MosquittoMonitorUpdater >> mqttClient [
	^ mqttClient
]

{ #category : #initialization }
MosquittoMonitorUpdater >> mqttClient: anObject [
	mqttClient := anObject
]

{ #category : #public }
MosquittoMonitorUpdater >> run [
	self setup.
	1 second wait.
	[ 
		[
			self webSocket sendMessage: self updateMessage. 
			5 seconds wait. 
			self webSocket isConnected ] whileTrue ]
		ensure: [ self cleanup ]
]

{ #category : #accessing }
MosquittoMonitorUpdater >> running [
	^ running
]

{ #category : #initialization }
MosquittoMonitorUpdater >> running: anObject [
	running := anObject
]

{ #category : #private }
MosquittoMonitorUpdater >> setup [
	self running: true.
	self mqttClient open; subscribeToTopic: '$SYS/broker/#'.
	self forkMqttListener
]

{ #category : #accessing }
MosquittoMonitorUpdater >> unrecognizedKeys [
	| keys |
	keys := self info keys asSet.
	self class keysAndFormatters do: [ :each |
		each second = #load
			ifTrue: [ 
				keys 
					remove: each first, '/1min' ifAbsent: [ ]; 
					remove: each first, '/5min' ifAbsent: [ ];
					remove: each first, '/15min' ifAbsent: [ ] ]
			ifFalse: [ keys remove: each first ifAbsent: [ ] ] ].
	^ keys
]

{ #category : #accessing }
MosquittoMonitorUpdater >> updateMessage [
	^ String streamContents: [ :out |
		self class keysAndFormatters do: [ :each | | key formatter value |
			formatter := (#format , each second capitalized) asMutator.
			key := each first.
			value := self perform: formatter with: key.
			out nextPutAll: key; nextPutAll: ' = '; nextPutAll: value.
			out crlf ] ]
]

{ #category : #accessing }
MosquittoMonitorUpdater >> webSocket [
	^ webSocket
]

{ #category : #initialization }
MosquittoMonitorUpdater >> webSocket: anObject [
	webSocket := anObject
]
