"
I am MQTTDisconnect.
I am an MQTTPacket.

I am a constant and hold no variable state.

The DISCONNECT Packet is the final Control Packet sent from the Client to the Server. It indicates that the Client is disconnecting cleanly.

After sending a DISCONNECT Packet the Client:
- MUST close the Network Connection
- MUST NOT send any more Control Packets on that Network Connection
 
On receipt of DISCONNECT the Server:
- MUST discard any Will Message associated with the current connection without publishing it
- SHOULD close the Network Connection if the Client has not already done so.
"
Class {
	#name : #MQTTDisconnect,
	#superclass : #MQTTPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTDisconnect >> typeTag [
	^ #disconnect
]
