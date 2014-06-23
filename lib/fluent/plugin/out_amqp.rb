require 'json'
module Fluent
  class AMQPOutput < BufferedOutput
    Plugin.register_output("amqp", self)

    config_param :host, :string, :default => nil
    config_param :user, :string, :default => "guest"
    config_param :pass, :string, :default => "guest"
    config_param :vhost, :string, :default => "/"
    config_param :port, :integer, :default => 5672
    config_param :ssl, :bool, :default => false
    config_param :verify_ssl, :bool, :default => false
    config_param :exchange, :string, :default => ""
    config_param :exchange_type, :string, :default => "direct"
    config_param :passive, :bool, :default => false
    config_param :durable, :bool, :default => false
    config_param :auto_delete, :bool, :default => false
    config_param :key, :string, :default => nil
    config_param :persistent, :bool, :default => false
    config_param :tag_key, :bool, :default => false
    config_param :tag_header, :string, :default => nil
    config_param :time_header, :string, :default => nil

    def initialize
      super
      require "bunny"
    end

    def configure(conf)
      super
      @conf = conf
      unless @host && @exchange
        raise ConfigError, "'host' and 'exchange' must be all specified."
      end
      unless @key || @tag_key
        raise ConfigError, "Either 'key' or 'tag_key' must be set."
      end
      @bunny = Bunny.new(:host => @host, :port => @port, :vhost => @vhost,
                         :pass => @pass, :user => @user, :ssl => @ssl, :verify_ssl => @verify_ssl)
    end

    def start
      super
      @bunny.start
      @exch = @bunny.exchange(@exchange, :type => @exchange_type.intern,
                              :passive => @passive, :durable => @durable,
                              :auto_delete => @auto_delete)
    end

    def shutdown
      super
      @bunny.stop
    end

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      chunk.msgpack_each do |(tag, time, data)|
        data = JSON.dump( data ) unless data.is_a?( String )
        @exch.publish(data, :key => routing_key( tag ), :persistent => @persistent, :headers => headers( tag, time ))
      end
    end

    def routing_key( tag )
      if @tag_key
        tag
      else
        @key
      end
    end

    def headers( tag, time )
      {}.tap do |h|
        h[@tag_header] = tag if @tag_header
        h[@time_header] = Time.at(time).utc.to_s if @time_header
      end
    end

  end
end
