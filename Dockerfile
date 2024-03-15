# Dockerfile

FROM ruby:2.7.8

WORKDIR /src
COPY . /src
RUN gem install bundler -v 2.1.4
RUN bundle install

EXPOSE 8081
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]