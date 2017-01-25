converting
asByteArray
	^ ByteArray streamContents: [ :out | self writeOn: out ]