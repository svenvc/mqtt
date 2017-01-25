reading
readStringFrom: binaryStream
	| bytes |
	bytes := self readBytesFrom: binaryStream.
	^ [ bytes utf8Decoded ]
		on: ZnInvalidUTF8
		do: [ String new: bytes size withAll: $? ] 