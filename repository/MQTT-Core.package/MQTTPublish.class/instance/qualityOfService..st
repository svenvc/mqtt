initialize-release
qualityOfService: integer
	self assert: (self class qualityOfServiceLevels includes: integer).
	qualityOfService := integer