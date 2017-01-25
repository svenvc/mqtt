comparing
= anObject
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self class instVarNames allSatisfy: [ :each | 
		(self perform: each) = (anObject perform: each) ]