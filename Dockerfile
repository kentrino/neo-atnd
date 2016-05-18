FROM ruby:2.3.1-alpine

MAINTAINER Kento Haneda <kento@haneda.me>

ENV BUILD_PACKAGES="ruby-dev build-base mysql-dev git" \
    PACKAGES="libxml2-dev zlib-dev linux-headers libxslt-dev tzdata nodejs" \
    RAILS_VERSION="4.2.6" \
    RAILS_ENV=production \
    BUNDLE_GEMFILE=/var/www/app/Gemfile \
    RAILS_ROOT=/var/www/app \
    GROUP_ID=55 \
    APP_USER_ID=1055 \
    NGINX_USER_ID=1060

RUN \
  mkdir /var/www && \
  mkdir /var/www/app && \
  apk --update upgrade && \
  apk --no-cache add $BUILD_PACKAGES $PACKAGES $DEV_PACKAGES && \

  # gem no document setting
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc  && \

  gem install nokogiri -- --use-system-libraries && \
  gem install rails --version "$RAILS_VERSION" && \
  git clone https://github.com/kentrino/neo-atnd $RAILS_ROOT && \
  bundle install && \
  cd /var/www/app && \
  rake assets:precompile && \

  # security settings =====================================================
  addgroup nginx -g $GROUP_ID && \
  adduser -D -H -G nginx -u $APP_USER_ID app && \
  adduser -D -H -G nginx -u $NGINX_USER_ID nginx && \
  chown -R app:nginx /var/www/app && \
  chmod -R go-rwx /var/www/app && \

  # log files
  # socket file will get 777 by unicorn
  # TODO: socket file should be changed to 770?
  chown -R nginx:nginx /var/www/app/log/nginx && \
  chmod -R u+rwx /var/www/app/log/nginx && \

  # socket file
  chown -R nginx:nginx /var/www/app/tmp && \
  chmod -R ug+rwx /var/www/app/tmp && \

  # public folder
  chown -R nginx:nginx /var/www/app/public && \
  chmod -R g+r /var/www/app/public && \

  # cleanup ===============================================================
  # mysql
  cp -L /usr/lib/libmysqlclient.so.18 ~/ && \
  apk del $BUILD_PACKAGES && \
  mv ~/libmysqlclient.so.18 /usr/lib && \

  find / -type f -iname \*.apk-new -delete && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem

USER app
WORKDIR /var/www/app

ENTRYPOINT ["bundle", "exec", "unicorn", "-c", "./config/unicorn.rb"]
