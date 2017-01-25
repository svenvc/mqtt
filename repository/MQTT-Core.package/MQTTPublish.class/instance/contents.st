accessing
contents
	^ self hasMessage ifTrue: [ self message ] ifFalse: [ #[ ] ]