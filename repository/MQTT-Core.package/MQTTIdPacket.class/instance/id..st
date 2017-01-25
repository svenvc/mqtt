initialize-release
id: integer
	self assert: (integer between: 0 and: 16rffff).
	id := integer