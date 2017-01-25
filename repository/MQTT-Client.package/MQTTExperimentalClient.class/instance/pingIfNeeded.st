private
pingIfNeeded
	self keepalive isZero
		ifTrue: [ ^ self ].
	(Time millisecondsSince: self lastActivity) / 1000 > self keepalive
		ifTrue: [ ^ self ping ]