private
enforceKeepaliveTimoutRelation
	self assert: (self keepalive isZero or: [ self timeout <= self keepalive ])