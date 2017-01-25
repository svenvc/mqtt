printing
printOn: stream
	super printOn: stream.
	stream
		nextPut: $(;
		nextPutAll: self returnCodeMeaning;
		nextPutAll: ' - ';
		nextPutAll:
				(self sessionPresent
						ifTrue: [ 'session present' ]
						ifFalse: [ 'session not present' ]);
		nextPut: $)