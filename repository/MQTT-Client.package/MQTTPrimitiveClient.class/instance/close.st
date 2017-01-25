initialize-release
close
	connection
		ifNotNil: [ 
			[ self writePacket: MQTTDisconnect new.
			 connection close ] on: Error do: [ ].
			connection := nil ].
	self subscriptions removeAll.
	^ true