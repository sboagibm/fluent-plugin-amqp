module Fluent
  class AMQPInput < Input
    Fluent::Plugin.register_input('amqp', self)

    # Define `router` method of v0.12 to support v0.10.57 or earlier
    unless method_defined?(:router)
      define_method("router") { Engine }
    end

    config_param :tag, :string, :default => "hunter.amqp"

    config_param :host, :string, :default => nil
    config_param :user, :string, :default => "guest"
    config_param :pass, :string, :default => "guest"
    config_param :vhost, :string, :default => "/"
    config_param :port, :integer, :default => 5672
    config_param :ssl, :bool, :default => false
    config_param :verify_ssl, :bool, :default => false
    config_param :heartbeat, :integer, :default => 0
    config_param :queue, :string, :default => nil
    config_param :durable, :bool, :default => false
    config_param :exclusive, :bool, :default => false
    config_param :auto_delete, :bool, :default => false
    config_param :passive, :bool, :default => false
    config_param :payload_format, :string, :default => "json"

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
      unless @host && @queue
        raise ConfigError, "'host' and 'queue' must be all specified."
      end
      @bunny = Bunny.new(:host => @host, :port => @port, :vhost => @vhost,
                         :pass => @pass, :user => @user, :ssl => @ssl,
                         :verify_ssl => @verify_ssl, :heartbeat => @heartbeat)
    end

    def start
      super
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @bunny.stop
      @thread.join
      super
    end

    def run
      @bunny.start
      q = @bunny.queue(@queue, :passive => @passive, :durable => @durable,
                       :exclusive => @exclusive, :auto_delete => @auto_delete)
      q.subscribe do |_, _, msg|
        payload = parse_payload(msg)
        router.emit(@tag, Time.new.to_i, payload)
      end
    end # AMQPInput#run

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
  end # class AMQPInput

end # module Fluent
