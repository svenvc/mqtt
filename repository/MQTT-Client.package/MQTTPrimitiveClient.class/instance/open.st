initialize-release
open
	| packet |
	self close.
	self openConnection.
	self writePacket: self newConnectPacket.
	packet := self readPacket.
	self assert: packet isAccepted.
	^ true