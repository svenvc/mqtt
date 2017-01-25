accessing
connectFlags
	| byte |
	byte := self willQoS << 3.
	byte := byte bitAt: 2 put: self cleanSession asBit.
	byte := byte bitAt: 3 put: self hasWill asBit.
	byte := byte bitAt: 6 put: self willRetain asBit.
	byte := byte bitAt: 7 put: self hasPassword asBit.
	byte := byte bitAt: 8 put: self hasUsername asBit.
	^ byte