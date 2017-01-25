private
readPayloadFrom: binaryStream using: connectFlags
	self keepalive: (self readInt16From: binaryStream).
	self clientId: (self readStringFrom: binaryStream).
	(connectFlags bitAt: 3) = 1
		ifTrue: [ 
			self willTopic: (self readStringFrom: binaryStream).
			self willMessage: (self readBytesFrom: binaryStream) ].
	(connectFlags bitAt: 8) = 1
		ifTrue: [ self username: (self readStringFrom: binaryStream) ].
	(connectFlags bitAt: 7) = 1
		ifTrue: [ self password: (self readBytesFrom: binaryStream) ]