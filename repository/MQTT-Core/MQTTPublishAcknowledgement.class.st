"
I am MQTTPublishAcknowledgement.
I am an MQTT(Id)Packet.

A PUBACK Packet is the response to a PUBLISH Packet with QoS level 1.

See also MQTTPublish
"
Class {
	#name : #MQTTPublishAcknowledgement,
	#superclass : #MQTTIdPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPublishAcknowledgement >> typeTag [
	^ #puback
]
