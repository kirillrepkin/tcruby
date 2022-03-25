FROM ruby:3.0.0
WORKDIR /app
COPY Gemfile Gemfile.lock money_transfer_app.rb config.ru Rakefile db app ./
RUN apt-get install libpq-dev && bundle install
EXPOSE 8080
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]