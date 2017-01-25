private
failedToReadInTimeout
	^ ConnectionTimedOut signal: 'Could not read matching packet before timeout'