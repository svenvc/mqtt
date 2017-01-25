writing
writeVariableHeaderOn: binaryStream
	self isIdRequired ifTrue: [ self writeInt16: self id on: binaryStream ]