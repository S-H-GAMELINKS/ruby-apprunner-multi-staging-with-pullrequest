FROM ruby:3.1

RUN apt-get update && \
    apt-get install -y postgresql-client

WORKDIR /app

COPY . ./

RUN gem install bundler:2.3.13 && \
    bundle install

EXPOSE 4567
CMD ["bundle", "exec", "ruby", "main.rb"]
