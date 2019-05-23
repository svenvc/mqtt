"
I am MQTTPublishReceived.
I am an MQTT(Id)Packet.

A PUBREC Packet is the response to a PUBLISH Packet with QoS 2. It is the second packet of the QoS 2 protocol exchange.

See also MQTTPublish, MQTTPublishRelease and MQTTPublishComplete.
"
Class {
	#name : #MQTTPublishReceived,
	#superclass : #MQTTIdPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPublishReceived >> response [
	^ MQTTPublishRelease new id: self id; yourself
]

{ #category : #accessing }
MQTTPublishReceived >> typeTag [
	^ #pubrec
]
