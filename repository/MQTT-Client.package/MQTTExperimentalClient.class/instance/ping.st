public
ping
	"Send a ping request and wait for a ping reply."
	
	| ping expectedResponse |
	ping := MQTTPingRequest new.
	self writePacket: ping.
	expectedResponse := ping response.
	self readSuchThat: [ :packet | packet = expectedResponse ].
	^ true