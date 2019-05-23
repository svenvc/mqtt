"
I am MQTTPingRequest.
I am an MQTTPacket.

I am a constant and hold no variable state.

The PINGREQ Packet is sent from a Client to the Server. It can be used to:
- Indicate to the Server that the Client is alive in the absence of any other Control Packets being sent from the Client to the Server.
- Request that the Server responds to confirm that it is alive.
- Exercise the network to indicate that the Network Connection is active.

This Packet is used in Keep Alive processing.

See MQTTPingResponse.
"
Class {
	#name : #MQTTPingRequest,
	#superclass : #MQTTPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPingRequest >> response [
	^ MQTTPingResponse new
]

{ #category : #accessing }
MQTTPingRequest >> typeTag [
	^ #pingreq
]
