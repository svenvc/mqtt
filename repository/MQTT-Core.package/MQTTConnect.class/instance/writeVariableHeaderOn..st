writing
writeVariableHeaderOn: binaryStream
	self writeString: 'MQTT' on: binaryStream.
	binaryStream nextPut: self protocolLevel.
	binaryStream nextPut: self connectFlags.
	self writeInt16: self keepalive on: binaryStream 