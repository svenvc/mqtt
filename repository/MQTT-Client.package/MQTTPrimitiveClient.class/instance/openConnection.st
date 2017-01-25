private
openConnection
	| address |
	address := NetNameResolver addressForName: self host timeout: self timeout.
	connection := ZdcSocketStream
		openConnectionToHost: address
		port: self port
		timeout: self timeout