"
Connect to broker.mqtt-dashboard.com
"
Class {
	#name : #MQTTExperimentalClientTests3,
	#superclass : #MQTTExperimentalClientTests,
	#category : 'MQTT-Tests'
}

{ #category : #testing }
MQTTExperimentalClientTests3 class >> isAbstract [
	^ false
]

{ #category : #accessing }
MQTTExperimentalClientTests3 >> host [
	^ 'broker.mqtt-dashboard.com'
]

{ #category : #running }
MQTTExperimentalClientTests3 >> setUp [
	client := self clientClass new.
	client host: self host.
	client timeout: 30.
	client open
]
