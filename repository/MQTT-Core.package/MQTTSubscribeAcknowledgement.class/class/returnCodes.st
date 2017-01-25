accessing
returnCodes
	"Known return codes, index -> meaning"
	
	^ {
		0 -> 'Success - Maximum QoS 0'.
		1 -> 'Success - Maximum QoS 1'.
		2 -> 'Success - Maximum QoS 2'.
		128 -> 'Failure' } asDictionary