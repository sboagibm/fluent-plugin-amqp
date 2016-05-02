require 'time'

module Fluent
  ##
  # AMQPInput to be used as a Fluent SOURCE, reading messages from a RabbitMQ
  # message broker
  class AMQPInput < Input
    Fluent::Plugin.register_input('amqp', self)

    # Define `router` method of v0.12 to support v0.10.57 or earlier
    unless method_defined?(:router)
      define_method("router") { Engine }
    end

    # Bunny connection handle
    #   - Allows mocking for test purposes
    attr_accessor :connection

    config_param :tag, :string, :default => "hunter.amqp"

    config_param :host, :string, :default => nil
    config_param :hosts, :array, :default => nil
    config_param :user, :string, :default => "guest"
    config_param :pass, :string, :default => "guest", :secret => true
    config_param :vhost, :string, :default => "/"
    config_param :port, :integer, :default => 5672
    config_param :ssl, :bool, :default => false
    config_param :verify_ssl, :bool, :default => false
    config_param :heartbeat, :integer, :default => 60
    config_param :queue, :string, :default => nil
    config_param :durable, :bool, :default => false
    config_param :exclusive, :bool, :default => false
    config_param :auto_delete, :bool, :default => false
    config_param :passive, :bool, :default => false
    config_param :payload_format, :string, :default => "json"
    config_param :tag_key, :bool, :default => false
    config_param :tag_header, :string, :default => nil
    config_param :time_header, :string, :default => nil
    config_param :tls, :bool, :default => false
    config_param :tls_cert, :string, :default => nil
    config_param :tls_key, :string, :default => nil
    config_param :tls_ca_certificates, :array, :default => nil
    config_param :tls_verify_peer, :bool, :default => true
    config_param :bind_exchange, :bool, :default => false
    config_param :exchange, :string, :default => ""
    config_param :routing_key, :string, :default => "#"                       # The routing key used to bind queue to exchange - # = matches all, * matches section (tag.*.info)



    def initialize
      require 'bunny'
      super
    end


    def configure(conf)
      conf['format'] ||= conf['payload_format'] # legacy

      super

      parser = TextParser.new
      if parser.configure(conf, false)
        @parser = parser
      end

      @conf = conf
      unless (@host || @hosts) && @queue
        raise ConfigError, "'host(s)' and 'queue' must be all specified."
      end
      check_tls_configuration
    end

    def start
      super
      # Create a new connection, unless its already been provided to us
      @connection = Bunny.new get_connection_options unless @connection
      @connection.start
      @channel = @connection.create_channel
      q = @channel.queue(@queue, :passive => @passive, :durable => @durable,
                       :exclusive => @exclusive, :auto_delete => @auto_delete)
      if @bind_exchange
        log.info "Binding #{@queue} to #{@exchange}, :routing_key => #{@routing_key}"
        q.bind(exchange=@exchange, :routing_key => @routing_key)
      end

      q.subscribe do |delivery, meta, msg|
        log.debug "Recieved message #{@msg}"
        payload = parse_payload(msg)
        router.emit(parse_tag(delivery, meta), parse_time(meta), payload)
      end
    end # AMQPInput#run

    def shutdown
      log.info "Closing connection"
      @connection.stop
      super
    end

    private
    def parse_payload(msg)
      if @parser
        parsed = nil
        @parser.parse msg do |_, payload|
          if payload.nil?
            log.warn "failed to parse #{msg}"
            parsed = { "message" => msg }
          else
            parsed = payload
          end
        end
        parsed
      else
        { "message" => msg }
      end
    end

    def parse_tag( delivery, meta )
      if @tag_key && delivery.routing_key != ''
        delivery.routing_key
      elsif @tag_header && meta[:headers][@tag_header]
        meta[:headers][@tag_header]
      else
        @tag
      end
    end

    def parse_time( meta )
      if @time_header && meta[:headers][@time_header]
        Time.parse( meta[:headers][@time_header] ).to_i
      else
        Time.new.to_i
      end
    end

    def check_tls_configuration()
      if @tls
        unless @tls_key && @tls_cert
            raise ConfigError, "'tls_key' and 'tls_cert' must be all specified if tls is enabled."
        end
      end
    end

    def get_connection_options()
      hosts = @hosts ||= Array.new(1, @host)
      opts = {
        :hosts => hosts, :port => @port, :vhost => @vhost,
        :pass => @pass, :user => @user, :ssl => @ssl,
        :verify_ssl => @verify_ssl, :heartbeat => @heartbeat,
        :tls                 => @tls,
        :tls_cert            => @tls_cert,
        :tls_key             => @tls_key,
        :verify_peer         => @tls_verify_peer
      }
      opts[:tls_ca_certificates] = @tls_ca_certificates if @tls_ca_certificates
      return opts
    end

  end # class AMQPInput

end # module Fluent
