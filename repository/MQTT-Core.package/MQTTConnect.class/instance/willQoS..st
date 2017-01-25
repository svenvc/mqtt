initialize-release
willQoS: integer
	self assert: (self class qualityOfServiceLevels includes: integer).
	willQoS := integer