running
setUp
	client := self clientClass new.
	client host: self host.
	client timeout: 30.
	client open