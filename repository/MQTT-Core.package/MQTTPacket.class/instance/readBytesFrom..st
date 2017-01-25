reading
readBytesFrom: binaryStream
	| length |
	length := (binaryStream next: 2) asInteger.
	^ binaryStream next: length