writing
writePayloadOn: binaryStream
	self writeString: self clientId on: binaryStream.
	self hasWill
		ifTrue: [ 
			self writeString: self willTopic on: binaryStream.
			self writeBytes: self willMessage on: binaryStream ].
	self hasUsername
		ifTrue: [ self writeString: self username on: binaryStream ].
	self hasPassword
		ifTrue: [ self writeBytes: self password on: binaryStream ]