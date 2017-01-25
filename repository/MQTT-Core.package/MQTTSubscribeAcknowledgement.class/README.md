I am MQTTSubscribeAcknowledgement.
I am an MQTT(Id)Packet.

A SUBACK Packet is sent by the Server to the Client to confirm receipt and processing of a SUBSCRIBE Packet.
 
A SUBACK Packet contains a list of return codes, that specify the maximum QoS level that was granted in each Subscription that was requested by the SUBSCRIBE.

The order of return codes in the SUBACK Packet MUST match the order of Topic Filters in the SUBSCRIBE Packet.

See also MQTTSubscribe