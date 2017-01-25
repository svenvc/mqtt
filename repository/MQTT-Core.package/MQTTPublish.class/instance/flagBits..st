initialize-release
flagBits: integer
	self qualityOfService: (integer bitAnd: 2r110) >> 1.
	self retain: (integer bitAt: 1) = 1.
	self duplicate: (integer bitAt: 4) = 1