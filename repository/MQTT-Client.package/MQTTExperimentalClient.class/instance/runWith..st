public
runWith: block
	"Enter a loop reading messages, ignoring ConnectionTimedOut.
	Block is evaluated for each incoming message.
	When the loop ends, the receiver is #close-ed.
	ConnectionClosed can be signalled to exit the loop"
	
	[ [ [ 
		[ block value: self readMessage ]
			on: ConnectionTimedOut  
			do: [ "Ignore & continue" ] 
	] repeat
	] ensure: [ self close ]
	] on: ConnectionClosed do: [ "Ignore" ]