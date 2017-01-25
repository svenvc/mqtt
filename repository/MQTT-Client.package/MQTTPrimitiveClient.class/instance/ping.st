public
ping
	"Send a ping request and wait for a ping reply."
	
	| ping packet |
	ping := MQTTPingRequest new.
	self writePacket: ping.
	packet := self readPacket.
	self assert: packet = ping response.
	^ true