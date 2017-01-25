accessing
knownTypes
	"Return an Array of Symbols of the 14 known MQTT Control Packet types. Each position corresponds to the integer value of each type."
	
	^ #(connect connack publish puback pubrec pubrel pubcomp subscribe suback unsubscribe unsuback pingreq pingresp disconnect)