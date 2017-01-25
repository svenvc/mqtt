private
setFlagsFrom: connectFlags
	self willQoS: (connectFlags bitAnd: 2r11000) >> 3.
	self cleanSession: (connectFlags bitAt: 2) = 1.
	self willRetain: (connectFlags bitAt: 6) = 1