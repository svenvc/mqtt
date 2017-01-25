reading
readRemainingLengthFrom: binaryStream
	| length multiplier byte |
	length := 0.
	multiplier := 1.
	[
		byte := binaryStream next.
		length := length + ((byte bitAnd: 127) * multiplier).
		multiplier := multiplier * 128.
		self assert: multiplier < (128 ** 3).
		(byte bitAt: 8) = 1 ] whileTrue.
	^ length