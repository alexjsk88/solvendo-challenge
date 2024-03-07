# Dockerfile

FROM ruby:2.7.1

WORKDIR /src
COPY . /src
RUN gem install bundler:1.17.3
RUN bundle install

EXPOSE 8081
CMD ["bundle", "exec", "rackup", "-p", "8081", "-o", "0.0.0.0"]
