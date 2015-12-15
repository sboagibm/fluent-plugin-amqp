# fluent-plugin-amqp

Description goes here.

## Configration examples.


### in

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
|:heartbeat|:integer|0| |
|:queue|:string|nil| |
|:durable|:bool|false| |
|:exclusive|:bool|false| |
|:auto_delete|:bool|false| |
|:passive|:bool|false| |
|:payload_format|:string|"json"| |
|:tag_key|:bool|false| | |
|:tag_header|:string|nil| |
|:time_header|:string|nil| |

### out

|param|type|default|secret|
|----|----|----|----|
|:host|:string|nil| |
|:user|:string|"guest"| |
|:pass|:string|"guest"|true|
|:vhost|:string|"/"| |
|:port|:integer|5672| |
|:ssl|:bool|false| |
|:verify_ssl|:bool|false| |
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

