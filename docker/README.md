```
$ docker build docker -t local/fluent-plugin-amqp .
$ docker run -it --rm -p 15672:15672 local/fluent-plugin-amqp
```

open `http://${docker_ip}:15672/`. and login with `admin / password`.

