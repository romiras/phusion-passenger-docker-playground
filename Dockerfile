FROM phusion/passenger-ruby24:latest

# Set correct environment variables.
#ENV HOME /root
ENV RUBY_VERSION=2.4.10

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/ruby-2.5.*.sh
#RUN /pd_build/ruby-2.6.*.sh
#RUN /pd_build/ruby-2.7.*.sh
#RUN /pd_build/ruby-3.0.*.sh
#RUN /pd_build/jruby-9.3.*.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
#RUN /pd_build/nodejs.sh

# ...put your own build instructions here...

RUN mkdir -p /opt/local/share/mime/packages && \
	curl -o /opt/local/share/mime/packages/freedesktop.org.xml https://cgit.freedesktop.org/xdg/shared-mime-info/plain/freedesktop.org.xml.in?h=Release-1-9

RUN gem install racc -v 1.5.2
RUN gem install nokogiri -v 1.10.10
RUN gem install mimemagic -v 0.3.10
RUN gem install mini_portile2 -v 2.4.0

RUN gem install bundler -v '2.1.4'

COPY --chown=app:app ./src/Gemfile* /tmp/
RUN cd /tmp && bundle install

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default
ADD ./etc/nginx/sites-enabled/webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN mkdir /home/app/webapp

# This copies your web app with the correct ownership.
COPY --chown=app:app ./src /home/app/webapp

RUN cd /home/app/webapp && \
	bundle install --jobs 8 && \
	RAILS_ENV=${PASSENGER_APP_ENV} bundle exec rails secret && \
	RAILS_ENV=${PASSENGER_APP_ENV} bundle exec rails about

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
