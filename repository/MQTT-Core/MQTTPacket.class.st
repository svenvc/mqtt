"
I am MQTTPacket, an MQTT Control Packet.

I am abstract, my concrete subclasses implement the 14 known types.

I implement #readFrom: a binary stream on my class side - this will return a concrete instance.

My subclasses implement #writeOn: a binary stream.

References 

http://mqtt.org
https://en.wikipedia.org/wiki/MQTT
http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html

MIT License.
"
Class {
	#name : #MQTTPacket,
	#superclass : #Object,
	#category : 'MQTT-Core'
}

{ #category : #accessing }
MQTTPacket class >> atLeastOnce [
	"Quality of service level 1 - single acks, possible duplicates"
	
	^ 1
]

{ #category : #accessing }
MQTTPacket class >> atMostOnce [
	"Quality of service level 0 - no acks, send and forget"
	
	^ 0
]

{ #category : #accessing }
MQTTPacket class >> concreteSubclasses [
	"Return an Array of subclasses corresponding to the 14 known MQTT Control Packet types. Each position corresponds to the integer value of each type."
	
	^ { MQTTConnect. MQTTConnectAcknowledgement. MQTTPublish. MQTTPublishAcknowledgement. MQTTPublishReceived. MQTTPublishRelease. MQTTPublishComplete. MQTTSubscribe. MQTTSubscribeAcknowledgement. MQTTUnsubscribe. MQTTUnsubscribeAcknownledgement. MQTTPingRequest. MQTTPingResponse. MQTTDisconnect }
]

{ #category : #accessing }
MQTTPacket class >> exactlyOnce [
	"Quality of service level 2 - no loss, no duplicates"
	
	^ 2
]

{ #category : #'instance creation' }
MQTTPacket class >> fromByteArray: byteArray [
	^ self readFrom: byteArray readStream 
]

{ #category : #accessing }
MQTTPacket class >> knownTypes [
	"Return an Array of Symbols of the 14 known MQTT Control Packet types. Each position corresponds to the integer value of each type."
	
	^ #(connect connack publish puback pubrec pubrel pubcomp subscribe suback unsubscribe unsuback pingreq pingresp disconnect)
]

{ #category : #accessing }
MQTTPacket class >> qualityOfServiceLevelNames [
	^ #(atMostOnce atLeastOnce exactlyOnce)
]

{ #category : #accessing }
MQTTPacket class >> qualityOfServiceLevels [
	^ #(0 1 2)
]

{ #category : #'instance creation' }
MQTTPacket class >> readFrom: binaryStream [
	"Read/parse a binary representation of an instance of me from binaryStream and return it"

	| byte type flagBits packetClass packet |
	(byte := binaryStream next)
		ifNil: [ ConnectionClosed signal: 'Failed to read MQTT packet' ].
	type := byte >> 4.
	flagBits := byte bitAnd: 2r1111.
	packetClass := self concreteSubclasses at: type.
	packet := packetClass new.
	packet flagBits: flagBits.
	packet readFrom: binaryStream.
	^ packet

]

{ #category : #comparing }
MQTTPacket >> = anObject [
	^ self class = anObject class
]

{ #category : #converting }
MQTTPacket >> asByteArray [
	^ ByteArray streamContents: [ :out | self writeOn: out ]
]

{ #category : #writing }
MQTTPacket >> encodedBytesLength: bytes [
	^ 2 + bytes size
]

{ #category : #writing }
MQTTPacket >> encodedStringLength: string [
	^ 2 + (ZnCharacterEncoder utf8 encodedByteCountForString: string)
]

{ #category : #accessing }
MQTTPacket >> flagBits [
	^ 0
]

{ #category : #'initialize-release' }
MQTTPacket >> flagBits: integer [
	self assert: integer = self flagBits
]

{ #category : #comparing }
MQTTPacket >> hash [
	^ self class hash
]

{ #category : #accessing }
MQTTPacket >> payloadLength [
	^ 0
]

{ #category : #reading }
MQTTPacket >> readBytesFrom: binaryStream [
	| length |
	length := (binaryStream next: 2) asInteger.
	^ binaryStream next: length
]

{ #category : #'initialize-release' }
MQTTPacket >> readFrom: binaryStream [
	"Read/parse a binary representation of me from binaryStream and return it"
	
	^ self readRemainingLengthFrom: binaryStream
]

{ #category : #reading }
MQTTPacket >> readInt16From: byteStream [
	^ (byteStream next << 8) + byteStream next
]

{ #category : #reading }
MQTTPacket >> readRemainingLengthFrom: binaryStream [
	| length multiplier byte |
	length := 0.
	multiplier := 1.
	[
		byte := binaryStream next.
		length := length + ((byte bitAnd: 127) * multiplier).
		multiplier := multiplier * 128.
		self assert: multiplier <= (128 ** 3).
		(byte bitAt: 8) = 1 ] whileTrue.
	^ length
]

{ #category : #reading }
MQTTPacket >> readStringFrom: binaryStream [
	| bytes |
	bytes := self readBytesFrom: binaryStream.
	^ [ bytes utf8Decoded ]
		on: ZnInvalidUTF8
		do: [ String new: bytes size withAll: $? ] 
]

{ #category : #accessing }
MQTTPacket >> remainingLength [
	^ self variableHeaderLength + self payloadLength 
]

{ #category : #accessing }
MQTTPacket >> response [
	"Return a new package that is the expected response when I am received either client or server/broker side. Return nil when there is no expected response."
	
	^ nil
]

{ #category : #accessing }
MQTTPacket >> typeTag [
	"Return a constant Symbol describing my type.
	See my class side's #knownTypes"
	
	^ self subclassResponsibility
]

{ #category : #accessing }
MQTTPacket >> typeValue [
	"Return the constant Integer value of my type, 1 to 14"
	
	^ self class knownTypes indexOf: self typeTag
]

{ #category : #accessing }
MQTTPacket >> variableHeaderLength [
	^ 0
]

{ #category : #writing }
MQTTPacket >> writeBytes: bytes on: binaryStream [
	self assert: bytes size < 16rFFFF.
	self writeInt16: bytes size on: binaryStream.
	binaryStream nextPutAll: bytes 
]

{ #category : #writing }
MQTTPacket >> writeInt16: integer on: binaryStream [
	binaryStream 
		nextPut: (integer digitAt: 2); 
		nextPut: (integer digitAt: 1)

]

{ #category : #writing }
MQTTPacket >> writeLength: length on: binaryStream [
	| byte value |
	self assert: length <= 268435455.
	value := length.
	[
		byte := value \\ 128.
		value := value // 128.
		value > 0
			ifTrue: [ byte := byte bitAt: 8 put: 1 ].
		binaryStream nextPut: byte.
		value isZero ] whileFalse
]

{ #category : #writing }
MQTTPacket >> writeOn: binaryStream [
	"Write a binary representation of me on binaryStream"
	
	binaryStream nextPut: ((self typeValue << 4) bitXor: self flagBits).
	self writeRemainingLengthOn: binaryStream 
]

{ #category : #writing }
MQTTPacket >> writeRemainingLengthOn: binaryStream [
	self writeLength: self remainingLength on: binaryStream 
]

{ #category : #writing }
MQTTPacket >> writeString: string on: binaryStream [
	self writeBytes: string utf8Encoded on: binaryStream
]
