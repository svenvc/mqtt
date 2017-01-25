accessing
returnCodeMeaning
	^ self class returnCodes 
		at: self returnCode + 1
		ifAbsent: [ 'Unknown return code [{1}]' format: { self returnCode } ]