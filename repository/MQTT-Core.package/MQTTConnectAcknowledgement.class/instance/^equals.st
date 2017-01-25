comparing
= anObject
	^ self class = anObject class
		and: [ self returnCode = anObject returnCode
			and: [ self sessionPresent = anObject sessionPresent ] ]