FROM ruby:2.3.1-alpine

MAINTAINER Kento Haneda <kento@haneda.me>

ENV BUILD_PACKAGES="ruby-dev build-base mysql-dev git" \
    PACKAGES="libxml2-dev zlib-dev linux-headers libxslt-dev tzdata nodejs" \
    RAILS_VERSION="4.2.6" \
    RAILS_ENV=production \
    BUNDLE_GEMFILE=/var/www/app/Gemfile \
    RAILS_ROOT=/var/www/app

RUN \
  mkdir /var/www && \
  mkdir /var/www/app && \
  apk --update upgrade && \
  apk add $BUILD_PACKAGES $PACKAGES $DEV_PACKAGES && \

  # gem no document
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc  && \

  gem install nokogiri -- --use-system-libraries && \
  gem install rails --version "$RAILS_VERSION" && \
  git clone https://github.com/kentrino/neo-atnd $RAILS_ROOT && \
  bundle install && \
  cd /var/www/app && \
  rake assets:precompile && \

  # cleanup mysql
  cp -L /usr/lib/libmysqlclient.so.18 ~/ && \
  apk del $BUILD_PACKAGES && \
  mv ~/libmysqlclient.so.18 /usr/lib && \

  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem

WORKDIR /var/www/app

# You have to add these variables
#   DB_USERNAME
#   DB_HOST
#   DB_PASSWORD

ENTRYPOINT ["bundle", "exec", "unicorn", "-c", "./config/unicorn.rb"]
