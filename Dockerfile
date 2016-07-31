FROM ruby:2.3.1
MAINTAINER kfrz.code@gmail.com

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . ./

EXPOSE 3000
CMD rackup -p 3000 -o 0.0.0.0 