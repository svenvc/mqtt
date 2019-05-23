"
I am MQTTPingResponse.
I am an MQTTPacket.

I am a constant and hold no variable state.

A PINGRESP Packet is sent by the Server to the Client in response to a PINGREQ Packet. It indicates that the Server is alive.

This Packet is used in Keep Alive processing.

See MQTTPingRequest.
"
Class {
	#name : #MQTTPingResponse,
	#superclass : #MQTTPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPingResponse >> typeTag [
	^ #pingresp
]
