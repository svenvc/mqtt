I am MQTTPrimitiveClient.
I am an MQTTAbstractClient.

I am an experimental / proof of concept implementation of a simple MQTT client.

See MQTTExperimentalClient for a more robust implementation.

Implementation note:

We assume here that responses are synchroneous: i.e. there are no intervening messages of different types. This is most probably wrong, but on all tested servers so far this seems to work out fine, for simple interactions. This might no longer be the case when listening to a busy topic.