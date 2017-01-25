input/output
log: anObject
	| line |
	self debug ifFalse: [ ^ self ].
	line := String streamContents: [ :out |
		DateAndTime now printOn: out.
		out << ' [ ' << self clientId << ' ]'.
		out << ' - '.
		out << anObject value ].
	self crLog: line