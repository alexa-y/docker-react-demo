#!/bin/bash

set -e
# -----------------------------------------------------------
# Create database.yml script
(
cat <<EOF
development: &default
  adapter: postgresql
  encoding: utf8
  database: canvas_development
  pool: 5
  username: postgres
  password:
  host: <%= ENV['DB_PORT_5432_TCP_ADDR'] %>

test:
  <<: *default
  database: canvas_test

production:
  <<: *default
  database: canvas_production
EOF
) > config/database.yml

# -----------------------------------------------------------
# Create development-local.rb
(
cat <<EOF
config.cache_classes = true
config.action_controller.perform_caching = true
config.action_view.cache_template_loading = true
EOF
) > config/development-local.rb

# -----------------------------------------------------------
# Create domain.yml
(
cat <<EOF
test:
  domain: localhost

development:
  domain: "localhost:3000"

production:
  domain: "canvas.example.com"
  # whether this instance of canvas is served over ssl (https) or not
  # defaults to true for production, false for test/development
  ssl: true
  # files_domain: "canvasfiles.example.com"
EOF
) > config/domain.yml

rand_num=`openssl rand -base64 20`

# -----------------------------------------------------------
# Create security.yml
(
cat <<EOF
production:
  # replace this with a random string of at least 20 characters
  encryption_key: $rand_num

development:
  encryption_key: $rand_num

test:
  encryption_key: $rand_num
EOF
) > config/security.yml

echo "Building Base Image"
docker build -t docker_demo .

echo "Starting Postgresql"
docker run -d --name postgres postgres

sleep 5

echo "create/migrate db"
docker run --name docker_demo_temp --link postgres:db docker_demo bundle exec rake db:create
docker commit docker_demo_temp docker_demo
docker rm docker_demo_temp

echo "migrate db"
docker run --name docker_demo_temp --link postgres:db docker_demo bundle exec rake db:migrate
docker commit docker_demo_temp docker_demo
docker rm docker_demo_temp

echo "start docker_demo_lti"
docker run --rm --link postgres:db docker_demo bundle exec rspec spec

echo "shutdown postgres and delete"
docker stop postgres
docker rm postgres
