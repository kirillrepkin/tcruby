FROM ruby:3.0.0
WORKDIR /tcryby
ADD Gemfile Gemfile.lock config.ru Rakefile ./
ADD db ./db
ADD app ./app
RUN apt-get install libpq-dev && bundle install
EXPOSE 8080
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]