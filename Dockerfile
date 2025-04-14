FROM ruby:3.3-bookworm

ENV BUNDLE_PATH=/bundle

# Install apt signing keys
RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    gpg --dearmor -o /usr/share/keyrings/pgdg.gpg

# Add apt repositories
RUN echo 'deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main' \
    > /etc/apt/sources.list.d/nodesource.list && \
    echo 'deb [signed-by=/usr/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main' \
    > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update

# Install packages
RUN apt-get install -y --no-install-recommends \
    chromium chromium-driver nodejs postgresql-client-16

# Create the crash reports directory - without it Chromium complains on startup
RUN mkdir -p "/root/.config/chromium/Crash Reports/pending/"

# Install NPM
RUN npm install -g npm@11

# Install Bundler
RUN gem install bundler -v 2.5.23

WORKDIR /app

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
