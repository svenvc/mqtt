printing
printOn: stream
	super printOn: stream.
	stream
		nextPut: $(;
		nextPutAll: self clientId;
		nextPutAll: ' - ';
		nextPutAll:
				(self cleanSession
						ifTrue: [ 'clean session' ]
						ifFalse: [ 'resume session' ]);
		nextPut: $)