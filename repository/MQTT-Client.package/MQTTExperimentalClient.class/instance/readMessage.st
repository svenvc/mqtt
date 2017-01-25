public
readMessage
	"Read a message while handling the necessary QoS flows.
	Only application messages with an actual payload will be returned.
	Might fail with ConnectionTimedOut."

	^ self readSuchThat: [ :packet | packet isApplicationMessage ]