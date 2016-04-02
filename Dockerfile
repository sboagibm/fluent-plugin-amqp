FROM centos:6
MAINTAINER sawanoboriyu@higanworks.com

RUN yum -y update
RUN yum install -y vim epel-release tmux logrotate initscripts sudo

## Rabbitmq and depends
RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN rpm -ivh https://www.rabbitmq.com/releases/erlang/erlang-17.4-1.el6.x86_64.rpm
RUN rpm -ivh https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.1/rabbitmq-server-3.5.1-1.noarch.rpm

## TD-Agent
RUN rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent
RUN rpm -ivh http://packages.treasuredata.com.s3.amazonaws.com/2/redhat/6/x86_64/td-agent-2.3.0-0.el6.x86_64.rpm

EXPOSE 5671 5672 15672 25672 20001

ADD . /fluent-plugin-amqp
WORKDIR /fluent-plugin-amqp
RUN /opt/td-agent/embedded/bin/gem build fluent-plugin-amqp.gemspec
RUN td-agent-gem install -VV fluent-plugin-amqp-*.gem

VOLUME /fluent-plugin-amqp

ENTRYPOINT ["docker/entrypoint.sh"]
