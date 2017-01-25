testing
isSubscription: index acceptedWithQoS: qos
	| code |
	self hasReturnCodes ifFalse: [ ^ false ].
	code := self returnCodes at: index ifAbsent: [ ^ false ].
	^ code = qos