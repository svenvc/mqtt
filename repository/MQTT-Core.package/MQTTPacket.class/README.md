I am MQTTPacket, an MQTT Control Packet.

I am abstract, my concrete subclasses implement the 14 known types.

I implement #readFrom: a binary stream on my class side - this will return a concrete instance.

My subclasses implement #writeOn: a binary stream.

References 

http://mqtt.org
https://en.wikipedia.org/wiki/MQTT
http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html

MIT License.