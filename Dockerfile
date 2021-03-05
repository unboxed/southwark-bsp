FROM ruby:2.7.2

# Match our Bundler version
RUN gem install bundler -v 2.2.8

WORKDIR /gems

COPY Gemfile Gemfile.lock ./

RUN bundle

WORKDIR /app

COPY . .

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
