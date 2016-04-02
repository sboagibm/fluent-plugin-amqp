```
$ docker build docker -t local/fluent-plugin-amqp .
$ docker run -it --rm -p 15672:15672 local/fluent-plugin-amqp
```

open `http://${docker_ip}:15672/`. and login with `admin / password`.

## Alternative configuration

If you wish to test/use the AMPQ in output mode (ie matcher) then you can use
the fluentd-out.conf in the test/fixtures directory by starting the Container
with the following run command instead;

```
$ docker run -it --rm -p 15672:15672 -p 20001:20001 local/fluent-plugin-amqp fluentd-out.conf
```

You then need to manually create a queue bound to `amq.direct` so your messages
will be kept by rabbitmq.

You can then emit messages to the brokers using the configured TCP source, with
a simple piped output;
```
$ echo '{ "test": 1}' | nc -q ${DOCKER_IP}:20001
```

Simply check RabbitMQ for any messages you've submitted (http://${DOCKER_IP}:15672/)
