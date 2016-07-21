#!/bin/bash
echo 'Enter heroku app name'
read herokuapp

command="heroku pg:backups capture -a $herokuapp"
echo $command
eval $command

command=$(curl -o latest.dump `heroku pg:backups public-url -a $herokuapp`)
echo $command
eval $command

command="bundle exec rake db:drop"
echo $command
eval $command

command="bundle exec rake db:create"
echo $command
eval $command

echo 'Enter database user'
read databaseuser

echo 'Enter database name'
read database

command="pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $databaseuser -d $database latest.dump"
echo $command
eval $command

command="rm latest.dump"
echo $command
eval $command

command="bundle exec rake db:migrate"
echo $command
eval $command
