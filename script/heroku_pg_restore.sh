#!/bin/bash
heroku pg:backups capture
curl -o latest.dump `heroku pg:backups public-url -a YOUR-HEROKU-APP`
bundle exec rake db:drop
bundle exec rake db:create
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U codestats -d codestats_development latest.dump
rm latest.dump
bundle exec rake db:migrate
