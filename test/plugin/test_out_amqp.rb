
require_relative '../helper'
require 'fluent/test'
require 'fluent/plugin/out_amqp'

# Protection against optional dependency - Ruby 1.9 can't
# include bunny-mock as its not supported
begin
  require 'bunny-mock'
rescue LoadError
  # Bunny-Mock requires Ruby 2+ and we're probably running on
  # 1.9 - so the require explodes
end

class AMPQOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end


  CONFIG = %[
    type amqp
    format json
    host amqp.example.com
    port 5672
    vhost /
    user guest
    pass guest
    exchange my_exchange
    tag_key true
  ]

  TLS_CONFIG = CONFIG + %[
    tls true
    tls_key "/etc/fluent/ssl/client.key.pem"
    tls_cert "/etc/fluent/ssl/client.crt.pem"
    tls_ca_certificates ["/etc/fluent/ssl/server.cacrt.pem", "/another/ca/cert.file"]
    tls_verify_peer true
  ]

  def create_driver(conf)
    Fluent::Test::OutputTestDriver.new(Fluent::AMQPOutput).configure(conf)
  end

  sub_test_case 'configuration' do
    test 'basic configuration' do
      configs = {'basic' => CONFIG}
      configs.merge!('tls' => TLS_CONFIG)

      configs.each_pair { |k, v|
        d = create_driver(v)
        assert_equal "amqp.example.com", d.instance.host
        assert_equal 5672, d.instance.port
        assert_equal "guest", d.instance.user
        assert_equal "/", d.instance.vhost
      }
    end

    test 'invalid tls configuration' do
      assert_raise_message(/'tls_key' and 'tls_cert' must be all specified if tls is enabled./) do
        create_driver(CONFIG + %[tls true])
      end
    end

    test 'invalid host configuration' do
      assert_raise_message(/'host' must be specified./) do
        create_driver(%[
          type amqp
          format json
          tag_key true
          ])
      end
    end

    test 'invalid tag / tag_key configuration' do
      assert_raise_message(/Either 'key' or 'tag_key' must be set./) do
        create_driver(%[
          type amqp
          format json
          host anywhere.example.com
          ])
      end
    end
  end

  sub_test_case 'connection handling' do

    test 'Exchange is created and bound to' do
      omit("BunnyMock is not avaliable") unless Object.const_defined?("BunnyMock")



      plugin = create_driver(CONFIG).instance
      plugin.connection = BunnyMock.new

      # Start the driver and wait while it initialises the threads etc
      plugin.start
      10.times { sleep 0.05 }

      # Should have created the 'logs' queue
      assert_equal true, plugin.connection.exchange_exists?('my_exchange')
      pend("Unable to check binding state - cant reach channel instance") {
        chnl = plugin.somehow_get_channel
        asset_equal true, chnl.bound_to?('my_exchange')
      }
    end

  end
end
