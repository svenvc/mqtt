writing
writeLength: length on: binaryStream
	| byte value |
	self assert: length <= 268435455.
	value := length.
	[
		byte := value \\ 128.
		value := value // 128.
		value > 0
			ifTrue: [ byte := byte bitAt: 8 put: 1 ].
		binaryStream nextPut: byte.
		value isZero ] whileFalse