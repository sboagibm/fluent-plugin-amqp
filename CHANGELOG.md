# 0.9.x

## 0.9.0

* Add support for Fluent 0.14.x

# 0.8.x

## 0.8.2

* Miscs: *no effect* Remove fixed date from gemspec #22

## 0.8.1

* Fix bug: TypeError with single RabbitMQ. #21

## 0.8.0

* Add automatic failover support for multiple hosts on same cluster. #19

# 0.7.x

## 0.7.1

* Sources can now automatically bind to exchanges [Issue #16](https://github.com/giraffi/fluent-plugin-amqp/issues/16)
* Refactored Docker container to use docker-compose and use multiple containers for testing source and matches concurrently

## 0.7.0

* TLS configuration supported [#15](https://github.com/giraffi/fluent-plugin-amqp/pull/15)
* Docker container created for testing [#13](https://github.com/giraffi/fluent-plugin-amqp/pull/13)

# 0.6.x

## 0.6.1

* Heartbeat added to outbound connections [#11](https://github.com/giraffi/fluent-plugin-amqp/pull/11)

## 0.6.0

*Breaking Change:* Ruby 2.0+ now required

* Updated dependencies for Bunny and Fluent to latest
* Changed default Heartbeat from 0 to 60 seconds

# < 0.5.x

* See commit history for breakdown of changes
