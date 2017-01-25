input/output
readFromInboxSuchThat: block
	| packet |
	packet := inbox detect: block ifNone: [ ^ nil ].
	inbox remove: packet.
	^ packet