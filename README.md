# MQTT for Pharo

[![Build Status](https://travis-ci.org/svenvc/mqtt.svg?branch=master)](https://travis-ci.org/svenvc/mqtt)

MQTT is a light-weight publish/subscribe messaging protocol, originally created around 1998. It is now an official open industry ISO standard. It is perfect for large-scale Internet of Things applications and high performance mobile messaging.

The publish/subscribe messaging pattern requires a message broker. The broker is responsible for distributing messages to interested clients based on the topic of a message. Parties communicating with each other over MQTT would all be clients in different roles, like producers and consumers, using the broker as middleware.

Many client libraries for different programming languages and multiple brokers/servers are available. Facebook Messenger and Amazon AWS IOT are two users, among many others.

A good client library for Pharo was not yet available. I started a new MQTT project and I am looking for collaborators to help me finish it. The official specification is quite readable and there is a lot of information available (see the References/Links section at the end).

Right now, the following features are available:

 - reading & writing of all 14 binary packet types
 - an experimental client with support for connection open/close, ping, subscribe/unsubscribe, QoS levels 0 (at most once), 1 (at least once) and 2 (exactly once) for application (publish) messages in both directions, message/package IDs and keep alive (heartbeat)
 - unit tests, for packet reading/writing and for clients against 3 publicly available sandbox/test brokers as well as against a local server

Basically, the code works but needs polishing and maturing. Also, it might be useful to experiment with alternative client API design. Not all features are yet implemented. It would also be nice to implement an actual server/broker, not to replace production quality servers, but as a proof of concept and tools during development.

## Code

Right now, documentation is limited, but there are class comments and the most important public API methods are commented too. The unit test show usage. There is a BaselineOf and a Metacello configuration, that load the 3 packages. There are no dependencies.

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

