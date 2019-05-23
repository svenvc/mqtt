"
I am MQTTUnsubscribeAcknowledgement.
I am an MQTT(Id)Packet.

The UNSUBACK Packet is sent by the Server to the Client to confirm receipt of an UNSUBSCRIBE Packet.

See also MQTTUnsubscribe
"
Class {
	#name : #MQTTUnsubscribeAcknownledgement,
	#superclass : #MQTTIdPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTUnsubscribeAcknownledgement >> typeTag [
	^ #unsuback
]
