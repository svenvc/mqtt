testing
testConnectDefaultCustom
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
	