# fluent-plugin-amqp

Description goes here.

## Configration examples.


### in

```
<source>
  type amqp
  host amqp.example.com
  port 5672
  vhost /
  user guest
  pass guest
  queue logs
  format json
</source>
```

#### in params

|param|type|default|secret|
|----|----|----|---|
|:tag|:string|"hunter.amqp"| |
|:host|:string|nil| |
|:user|:string|"guest"| |
|:pass|:string|"guest"|true|
|:vhost|:string|"/"| |
|:port|:integer|5672| |
|:ssl|:bool|false| |
|:verify_ssl|:bool|false| |
|:heartbeat|:integer|60| |
|:queue|:string|nil| |
|:durable|:bool|false| |
|:exclusive|:bool|false| |
|:auto_delete|:bool|false| |
|:passive|:bool|false| |
|:payload_format|:string|"json"| |
|:tag_key|:bool|false| | |
|:tag_header|:string|nil| |
|:time_header|:string|nil| |
|:tls|:bool|false| |
|:tls_cert|:string|nil| |
|:tls_key|:string|nil| |
|:tls_ca_certificates|:array|nil| |
|:tls_verify_peer|:bool|true| |
|:bind_exchange|:boolean|false| |
|:exchange|:string|nil| |





### out

```
<match **.**>
  type amqp
  key my_routing_key
  exchange amq.direct
  host amqp.example.com
  port 5672
  vhost /
  user guest
  pass guest
</match>
```

#### out params

|param|type|default|secret|
|----|----|----|----|
|:host|:string|nil| |
|:user|:string|"guest"| |
|:pass|:string|"guest"|true|
|:vhost|:string|"/"| |
|:port|:integer|5672| |
|:ssl|:bool|false| |
|:verify_ssl|:bool|false| |
|:heartbeat|:integer|60| |
|:exchange|:string|""| |
|:exchange_type|:string|"direct"| |
|:passive|:bool|false| |
|:durable|:bool|false| |
|:auto_delete|:bool|false| |
|:key|:string|nil| |
|:persistent|:bool|false| |
|:tag_key|:bool|false| |
|:tag_header|:string|nil| |
|:time_header|:string|nil| |
|:tls|:bool|false| |
|:tls_cert|:string|nil| |
|:tls_key|:string|nil| |
|:tls_ca_certificates|:array|nil| |
|:tls_verify_peer|:bool|true| |

### Enable TLS Authentication

The example below shows how you can configure TLS authentication using signed encryption keys
which will be validated by your appropriately configured RabbitMQ installation.

For more information on setting up TLS encryption, see the [Bunny TLS documentation](http://rubybunny.info/articles/tls.html)

Note: The 'source' configuration accepts the same arguments.

```
<match **.**>
  type amqp
  key my_routing_key
  exchange amq.direct
  host amqp.example.com
  port 5671              # Note that your port may change for TLS auth
  vhost /
  user guest
  pass guest

  tls true
  tls_key "/etc/fluent/ssl/client.key.pem"
  tls_cert "/etc/fluent/ssl/client.crt.pem"
  tls_ca_certificates ["/etc/fluent/ssl/server.cacrt.pem", "/another/ca/cert.file"]
  tls_verify_peer true

</match>
```

## Docker Container

A docker container is included in this project to help with testing and debugging.

You can simply build the docker container's ready for use with the following;
```
docker-compose build
```

Start the cluster of three containers with;
```
docker-compose up
```

And finally, submit test events, one a second, to the built in tcp.socket source
with;

```
while [ true ] ; do echo "{ \"test\": \"$(date)\" }" | nc ${DOCKER_IP} 20001; sleep 1; done
```

## Contributing to fluent-plugin-amqp

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Hiromi Ishii. See LICENSE.txt for
Copyright (c) 2013- github/giraffi. See LICENSE.txt for
further details.
