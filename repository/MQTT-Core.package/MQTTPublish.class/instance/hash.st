comparing
hash
	^ self class instVarNames 
		inject: 0 
		into: [ :acc :each | acc bitXor: (self perform: each) hash ]