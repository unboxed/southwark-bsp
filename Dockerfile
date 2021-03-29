FROM ruby:2.7.2

# Match our Bundler version
RUN gem install bundler -v 2.2.13

## Install gems in a separate Docker fs layer
WORKDIR /gems
COPY Gemfile Gemfile.lock ./
RUN bundle

## Node
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

## Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

## Install yarn dependencies in a separate Docker fs layer
WORKDIR /js
COPY package.json yarn.lock ./
RUN yarn

WORKDIR /app

COPY . .

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
