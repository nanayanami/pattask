#!/usr/bin/env bash
# exit on error
set -o errexit
set -o pipefail

apt-get update -qq && \
  apt-get install --no-install-recommends -y libpq-dev nodejs && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

bundle install
bundle exec rails assets:precompile