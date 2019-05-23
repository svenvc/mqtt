"
Connect to broker.mqtt-dashboard.com
"
Class {
	#name : #MQTTKeepaliveTests3,
	#superclass : #MQTTKeepaliveTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTKeepaliveTests3 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTKeepaliveTests3 >> host [
	^ 'broker.mqtt-dashboard.com'
]
