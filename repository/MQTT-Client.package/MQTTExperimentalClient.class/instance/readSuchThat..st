public
readSuchThat: block
	"Read a message while handling the necessary QoS flows.
	Only application messages for which block evaluates to true will be returned.
	Might fail with ConnectionTimedOut."

	| packet started |
	self pingIfNeeded.
	started := Time millisecondClockValue.
	[
		(self readFromInboxSuchThat: block) 
			ifNotNil: [ :found | ^ found ].
		packet := self readPacketWithQoSFlow.
		(block value: packet)
			ifTrue: [ ^ packet ]
			ifFalse: [ inbox add: packet ].
		(Time millisecondsSince: started) / 1000 > self timeout
			ifTrue: [ ^ self failedToReadInTimeout ] ] repeat