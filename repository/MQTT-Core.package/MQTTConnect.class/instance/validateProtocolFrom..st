private
validateProtocolFrom: binaryStream
	self assert: (self readStringFrom: binaryStream) = 'MQTT'.
	self assert: binaryStream next = self protocolLevel