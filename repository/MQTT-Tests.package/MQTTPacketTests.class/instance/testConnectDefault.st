testing
testConnectDefault
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
	