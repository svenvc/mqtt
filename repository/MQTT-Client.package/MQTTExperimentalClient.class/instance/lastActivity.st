accessing
lastActivity
	^ lastActivity ifNil: [ self touch ]