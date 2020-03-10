"
I am MosquittoMonitorHandler.

NeoConsoleEnvironment current 
	at: #Mosquitto_Monitor_MQTT_URL put: 'mqtt://localhost';
	at: #Mosquitto_Monitor_WS_URL put: 'ws://localhost:9090/ws-mosquitto-monitor'.
	
NeoConsoleEnvironment current
	at: #Mosquitto_Monitor_MQTT_URL put: 'mqtt://test.mosquitto.org'.

"
Class {
	#name : #MosquittoMonitorHandler,
	#superclass : #Object,
	#classVars : [
		'Token'
	],
	#category : #'MQTT-MosquittoMonitor'
}

{ #category : #accessing }
MosquittoMonitorHandler class >> clientHtml [
	^ ZnHtmlOutputStream streamContents: [ :html |
		html html5; tag: #html do:	[
			html tag: #head do: [ 
				html tag: #title with: 'Mosquitto Monitor'.
				html tag: #script attributes: #(language javascript type 'text/javascript') do: [ 
					html nextPutAll: self javascript ] ].
			html tag: #body do: [ 
				html tag: #h1 with: 'Mosquitto Monitor'.
				html tag: #div do: [ 
					html tag: #pre id: #info with: 'waiting for connection ...' ].
				html tag: #script attributes: #(language javascript type 'text/javascript') do: [ 
					html nextPutAll: ('window.setup_live_monitoring("{1}","{2}")' format: { self wsUrl. self token }) ] ] ] ]
]

{ #category : #installation }
MosquittoMonitorHandler class >> installInServer: server [
	"self installInServer: ZnServer default"
	
	"ZnServer default authenticator: (ZnBasicAuthenticator username: 'admin' password: 'mqtt1883')"
	
	server delegate
		map: 'mosquitto-monitor' to: [ :request | ZnResponse ok: (ZnEntity html: self clientHtml) ];
		map: 'ws-mosquitto-monitor' to: (ZnWebSocketDelegate handler: self new).
]

{ #category : #accessing }
MosquittoMonitorHandler class >> javascript [
	^ '/* Javascript code to support Live Monitoring */

var websocket;
var token;

function setup_live_monitoring(ws_url, token_str) {
	token = token_str;
	websocket = new WebSocket(ws_url);
	websocket.onmessage = function(evt) { on_message(evt) };
	websocket.onopen = function(evt) { on_open(evt) };
}

function on_open(evt) { 
	do_update_element("info", "waiting for data ...");
	websocket.send(token);
}

function on_message(evt) {
	do_update_element("info", evt.data);
}

function do_update_element(id, string) {
	var element = document.getElementById(id);
	if (element != null) {
		element.innerHTML = string;
	}
}
'
]

{ #category : #accessing }
MosquittoMonitorHandler class >> mosquittoMqttUrl [
	^ NeoConsoleEnvironment current 
			at: #Mosquitto_Monitor_MQTT_URL 
			ifAbsent: [ 'mqtt://localhost' ]
]

{ #category : #installation }
MosquittoMonitorHandler class >> resetToken [
	^ Token := 1e6 atRandom
]

{ #category : #accessing }
MosquittoMonitorHandler class >> token [
	^ Token ifNil: [ self resetToken ]
]

{ #category : #accessing }
MosquittoMonitorHandler class >> wsUrl [
	^ NeoConsoleEnvironment current 
			at: #Mosquitto_Monitor_WS_URL
			ifAbsent: 'ws://localhost:9090/ws-mosquitto-monitor'
]

{ #category : #private }
MosquittoMonitorHandler >> loop: webSocket [
	MosquittoMonitorUpdater new
		webSocket: webSocket;
		mqttClient: self mqttClient;
		run.
]

{ #category : #accessing }
MosquittoMonitorHandler >> mqttClient [
	^ MQTTClient new
		url: self class mosquittoMqttUrl;
		keepalive: 60;
		clientId: 'mosquitto-monitor';
		cleanSession: true;
		atMostOnce;
		debug: true;
		yourself
]

{ #category : #accessing }
MosquittoMonitorHandler >> value: webSocket [
	[ 
		webSocket logGeneric: 'Started monitoring'.
		webSocket readMessage asString = self class token asString
			ifTrue: [ self loop: webSocket ]
			ifFalse: [ self error: 'invalid token, not authorized' ] ] 
		on: NetworkError  
		do: [ webSocket logGeneric: 'Ignoring network error' ].
	webSocket logGeneric: 'Stopping monitoring'
]
