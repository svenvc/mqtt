"
I am MQTTPublishComplete.
I am an MQTT(Id)Packet.

The PUBCOMP Packet is the response to a PUBREL Packet. It is the fourth and final packet of the QoS 2 protocol exchange.

See also MQTTPublish, MQTTPublishReceived and MQTTPublishRelease.
"
Class {
	#name : #MQTTPublishComplete,
	#superclass : #MQTTIdPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPublishComplete >> typeTag [
	^ #pubcomp
]
