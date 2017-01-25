initialize-release
addReturnCode: code
	self assert: (self class returnCodeValues includes: code).
	self returnCodes add: code