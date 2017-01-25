accessing
port
	^ port ifNil: [ port := 1883 ]