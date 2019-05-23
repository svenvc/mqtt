"
I am MQTTPublishRelease.
I am an MQTT(Id)Packet.

A PUBREL Packet is the response to a PUBREC Packet. It is the third packet of the QoS 2 protocol exchange.

See also MQTTPublish, MQTTPublishReceived and MQTTPublishComplete
"
Class {
	#name : #MQTTPublishRelease,
	#superclass : #MQTTIdPacket,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPublishRelease >> flagBits [
	^ 2r0010
]

{ #category : #accessing }
MQTTPublishRelease >> response [
	^ MQTTPublishComplete new id: self id; yourself
]

{ #category : #accessing }
MQTTPublishRelease >> typeTag [
	^ #pubrel
]
