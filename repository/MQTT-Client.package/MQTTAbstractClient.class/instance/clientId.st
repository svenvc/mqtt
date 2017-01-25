accessing
clientId
	^ clientId ifNil: [ clientId := self class name asString ]