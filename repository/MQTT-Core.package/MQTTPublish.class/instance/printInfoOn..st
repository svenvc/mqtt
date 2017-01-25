printing
printInfoOn: stream
	super printInfoOn: stream.
	stream
		space; nextPutAll: self topic;
		space; print: self messageSize; nextPutAll: 'B';
		space; << 'QoS='; print: self qualityOfService.
	self duplicate ifTrue: [ stream << ' Duplicate' ].
	self retain ifTrue: [ stream << ' Retain' ]
		 