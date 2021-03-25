# MQTT for Pharo

[![CI](https://github.com/svenvc/mqtt/actions/workflows/CI.yml/badge.svg)](https://github.com/svenvc/mqtt/actions/workflows/CI.yml)

## MQTT

MQTT is a light-weight publish/subscribe messaging protocol, originally created around 1998. It is now an official open industry ISO standard. It is perfect for large-scale Internet of Things applications and high performance mobile messaging.

The publish/subscribe messaging pattern requires a message broker. The broker is responsible for distributing messages to interested clients based on the topic of a message. Parties communicating with each other over MQTT would all be clients in different roles, like producers and consumers, using the broker as middleware.

Many client libraries for different programming languages and multiple brokers/servers are available.

## MQTT for Pharo

This project implements a modern, documented and readable MQTT client library for Pharo.

The official specification is quite readable and there is a lot of information available (see the References/Links section at the end).

Right now, the following features are available:

 - reading & writing of all 14 binary packet types
 - support for connection open/close, ping, subscribe/unsubscribe, QoS levels 0 (at most once), 1 (at least once) and 2 (exactly once) for application (publish) messages in both directions, message/package IDs and keep alive (heartbeat)
 - use of an inbox when reading messages to store unexpected out of band messages, reading messages with a condition filter, handling keepalive and ping, programming in event driven style using #runWith:
 - unit tests, for packet reading/writing and for clients against 3 publicly available sandbox/test brokers as well as against a local server
 - support for MQTT version 3.1.1
 
## Usage

Send a single message to a topic to the local broker, say a temperature reading of a sensor, using QoS level 1.

````
MQTTClient new
    atLeastOnce;
    open;
    sendMessage: 20 asByteArray toTopic: '/device/42/outside-temperature';
    close.
````

Same message to a remote host, using the default QoS level 0.

````
MQTTClient new
    host: 'iot.example.com';
    open;
    sendMessage: 21 asByteArray toTopic: '/device/42/outside-temperature';
    close.
````

Read a single message, using QoS level 2 (client should be closed afterwards)

````
MQTTClient new
    exactlyOnce;
    open;
    subscribeToTopic: '/new-user-notifications';
    readMessage.
````

Read and collect 10 temperature readings 

````
Array streamContents: [ :stream | | count |
    count := 1.
    MQTTClient new
       open;
       subscribeToTopic: '/device/42/outside-temperature';
       runWith: [ :message |
         stream nextPut: message contents asInteger.
         (count := count + 1) > 10 ifTrue: [ ConnectionClosed signal ] ] ].
````

Collect 100 system notifications

````
Array streamContents: [ :stream | | count |
    count := 1.
    MQTTClient new
      host: 'iot.eclipse.org';
      open;
      subscribeToTopic: '$SYS/#';
      runWith: [ :message |
        stream nextPut: message.
        (count := count + 1) > 100 ifTrue: [ ConnectionClosed signal ] ] ].
````

## Code

Right now, documentation is limited to class comments and the most important public API methods. The unit test show usage. There is a BaselineOf that load the 3 packages. There are no dependencies.

```Smalltalk
Metacello new
  repository: 'github://svenvc/mqtt/repository';
  baseline: 'MQTT';
  load.
```

## References/Links

- [http://mqtt.org](http://mqtt.org)
- [https://en.wikipedia.org/wiki/MQTT](https://en.wikipedia.org/wiki/MQTT])
- [http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html])
- [https://github.com/mqtt/mqtt.github.io/wiki/software](https://github.com/mqtt/mqtt.github.io/wiki/software)
- [http://mosquitto.org](http://mosquitto.org)
- [https://github.com/emqtt/emqttd](https://github.com/emqtt/emqttd)
- [http://kamilfb.github.io/mqtt-spy/](http://kamilfb.github.io/mqtt-spy/)
- [https://github.com/eclipse/paho.mqtt-spy/wiki](https://github.com/eclipse/paho.mqtt-spy/wiki)
- [https://eclipse.org/paho/](https://eclipse.org/paho/)
- [https://eclipse.org/paho/clients/c/embedded/](https://eclipse.org/paho/clients/c/embedded/)
- [http://www.rabbitmq.com/mqtt.html](http://www.rabbitmq.com/mqtt.html)
- [https://vernemq.com](https://vernemq.com)
- [https://www.ibm.com/developerworks/community/blogs/c565c720-fe84-4f63-873f-607d87787327/entry/mqtt_security](https://www.ibm.com/developerworks/community/blogs/c565c720-fe84-4f63-873f-607d87787327/entry/mqtt_security)
- [http://www.hivemq.com/mqtt-essentials/](http://www.hivemq.com/mqtt-essentials/)

## Sandbox/test Servers/Brokers
- iot.eclipse.org:1883
- test.mosquitto.org:1883
- broker.mqtt-dashboard.com:1883
- localhost:1883
