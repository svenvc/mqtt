I am MQTTExperimentalClient.
I am an MQTTPrimitiveClient and a MQTTAbstractClient.

I am an experimental / proof of concept implementation of a simple MQTT client.

Examples:

Send a single message to a topic to the local broker, say a temperature reading of a sensor, using QoS level 1.

  MQTTExperimentalClient new
    atLeastOnce;
    open;
    sendMessage: 20 asByteArray toTopic: '/device/42/outside-temperature';
    close.

Same message to a remote host, using the default QoS level 0.

  MQTTExperimentalClient new
    host: 'iot.example.com';
    open;
    sendMessage: 21 asByteArray toTopic: '/device/42/outside-temperature';
    close.

Read a single message, using QoS level 2 (client should be closed afterwards)

  MQTTExperimentalClient new
    exactlyOnce;
    open;
    subscribeToTopic: '/new-user-notifications';
    readMessage.

Read and collect 10 temperature readings 

  Array streamContents: [ :stream | | count |
    count := 1.
    MQTTExperimentalClient new
       open;
       subscribeToTopic: '/device/42/outside-temperature';
       runWith: [ :message |
         stream nextPut: message contents asInteger.
         (count := count + 1) > 10 ifTrue: [ ConnectionClosed signal ] ] ].

Collect 100 system notifications

  Array streamContents: [ :stream | | count |
    count := 1.
    MQTTExperimentalClient new
      host: 'iot.eclipse.org';
      open;
      subscribeToTopic: '$SYS/#';
      runWith: [ :message |
        stream nextPut: message.
        (count := count + 1) > 100 ifTrue: [ ConnectionClosed signal ] ] ].

Implementation note:

I use an inbox when reading messages so that I can store unexpected out of band messages. 
Reading a message requires a condition filter.
I handle keepalive and ping.
I implement #runWith: to program in event driven style.