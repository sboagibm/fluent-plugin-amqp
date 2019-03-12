

FROM ruby:2.2

MAINTAINER Toby Jackson <toby@warmfusion.co.uk>
WORKDIR /fluentd
ADD . /fluentd

RUN gem build fluent-plugin-amqp.gemspec
RUN gem install -V fluent-plugin-amqp-sboagibm-*.gem

COPY /test/fixtures/ /etc/fluentd
VOLUME /etc/fluentd/

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

CMD exec fluentd -c /etc/fluentd/$FLUENTD_CONF $FLUENTD_OPT
