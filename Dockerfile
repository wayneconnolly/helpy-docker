FROM ubuntu:14.04
MAINTAINER Wayne Connolly <wayne@wayneconnolly.com>
RUN apt-get install -yq software-properties-common  && apt-add-repository ppa:brightbox/ruby-ng && apt-get update
RUN apt-get install -yq ruby2.2 ruby2.2-dev
RUN gem update --system 
RUN apt-get install -yq --force-yes build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev libpq-dev libpcap-dev nginx
RUN gem install rails --version=4.2
RUN gem install json -v '1.8.2' && gem install unf_ext -v '0.0.6' && gem install bcrypt -v '3.1.10' && gem install byebug -v '4.0.1' && gem install ffi -v '1.9.8' && gem install hitimes -v '1.2.2' && gem install raindrops -v '0.13.0' && gem install rdiscount -v '2.1.8' && gem install therubyracer -v '0.12.1' && gem install unicorn -v '4.8.3' && gem install web-console -v '2.1.2' && gem install pg -v '0.18.1'
RUN mkdir /var/www
ADD helpy /var/www/helpy
RUN ruby -v
RUN cd /var/www/helpy && bundle install --deployment
WORKDIR /var/www/helpy
ADD unicorn.conf /etc/unicorn.conf 
ADD unicorn /etc/default/unicorn
ADD nginx-sites.conf /etc/nginx/sites-enabled/default
ADD start-server.sh /usr/bin/start-server
RUN chmod +x /usr/bin/start-server
RUN touch /var/www/helpy/log/production.log
RUN chmod 0664 /var/www/helpy/log/production.log
RUN mkdir /var/log/unicorn/
RUN touch /var/log/unicorn/unicorn.log
RUN chmod 0644 /var/log/unicorn/unicorn.log
RUN ps
RUN RAILS_ENV=production rake assets:precompile
RUN RAILS_ENV=production rake db:create
RUN RAILS_ENV=production rake db:migrate
RUN RAILS_ENV=production rake db:seed
RUN sed '1 i daemon off;' /etc/nginx/nginx.conf 
RUN touch /var/run/unicorn.sock
RUN chmod 0644 /var/run/unicorn.sock
RUN touch /var/run/unicorn.pid
RUN chmod 0644 /var/run/unicorn.pid
EXPOSE 80 443
CMD service nginx start && bundle exec unicorn_rails -p 3000