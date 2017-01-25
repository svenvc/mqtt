accessing
newConnectPacket
	^ MQTTConnect new
		clientId: self clientId;
		username: self username;
		password: self password;
		keepalive: self keepalive;
		yourself