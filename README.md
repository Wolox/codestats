Code Stats
===============
[![Circle CI](https://circleci.com/gh/Wolox/codestats/tree/master.svg?style=svg)](https://circleci.com/gh/Wolox/codestats/tree/master)
[![Code Climate](https://codeclimate.com/github/Wolox/codestats/badges/gpa.svg)](https://codeclimate.com/github/Wolox/codestats)

Self-hosted open source app to control metrics of your code. Code Stats lets to control the quality of your code by integration your Github pull requests with any metric you want.

## How does it work?

By including the [Code Stats Metrics Reporter gem](https://github.com/Wolox/codestats-metrics-reporter) in your app and setting up the `.codestats.yml` file, your Continous Integration will run certains scripts that will let Code Stats list all the metrics you want and run custom checks whenever you create a Github Pull Request

## Badge

You can add a Code Stats badge to you README by adding the following:

```
[![Codestats](http://your-codestats-url/organizations/an-organization/projects/a-project/badge)]((http://your-codestats-url/organizations/an-organization/projects/a-project/badge)
```

it will look something like this:

![code stats error badge](public/badge-error-lightgrey.png?raw=true)
![code stats failed badge](public/checks-failed-red.png?raw=true)
![code stats success badge](public/checks-passed-green.png?raw=true)

### Screenshots

![Pull Request Integration](public/pull-request-integration.png?raw=true)
![Success Metric](public/success-metric.png?raw=true)
![Failed Metric](public/failed-metric.png?raw=true)

## Running local server

### 1- Installing Ruby

- Clone the repository by running `git clone git@github.com:Wolox/codestats.git`
- Go to the project root by running `cd codestats`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### 2- Installing Rails gems

- Install [Bundler](http://bundler.io/).
- Install basic dependencies if you are using Ubuntu:

```bash
  sudo apt-get install build-essential libpq-dev nodejs
```

- Install all the gems included in the project.

```bash
  gem install bundler --no-ri --no-rdoc
  rbenv rehash
  bundle -j 20
```

### Database Setup

Run in terminal:

```bash
  sudo -u postgres psql
  CREATE ROLE "codestats" LOGIN CREATEDB PASSWORD 'codestats';
```

Log out from postgres and run:

```bash
  bundle exec rake db:create db:migrate
```

Your server is ready to run. You can do this by executing `rails server` and going to [http://localhost:3000](http://localhost:3000). Happy coding!

## Deploy Guide

#### Heroku

If you want to deploy your app using [Heroku](https://www.heroku.com) you need to do the following:

- Add the Heroku Git URL
- Push to heroku
- Run migrations

```bash
  git remote add heroku-prod your-git-url
  git push heroku-prod your-branch:master
```

#### AWS

The gems and files needed to make a deploy to AWS with [Capistrano](http://capistranorb.com/) are included in this repo but commented. Feel free to use them.

## Rollbar Configuration

[Rollbar](https://rollbar.com/) is used for exception errors report. To complete this configuration setup the following environment variables in your server:

- `ROLLBAR_ACCESS_TOKEN` with the credentials located in the rollbar application.
- `ROLLBAR_ENVIRONMENT` with the environment name you want to be shown in Rollbar. This is usefull if you have different servers running in Production mode and you want to identify them in Rollbar.

## PGHero Authentication

Set the following variables in your server.

```bash
  PGHERO_USERNAME=username
  PGHERO_PASSWORD=password
```

And you can access the PGHero information by entering `/pghero`.

## Google Analyitics

Set the `GOOGLE_ANALYTICS_TOKEN` environment variable in your server.

## Credentials

You can use either environment variables or the [secrets.yml](config/secrets.yml). If you want to set environment variables in development you can add them to [.env.local](.env.local) (you can find an example in the [.env.local.example](.env.local.example) file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rspec tests (`bundle exec rspec spec -fd`)
5. Run rubocop lint (`bundle exec rubocop app spec -R`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request

Feel free to add a new Issue by clicking [here](https://github.com/Wolox/codestats/issues/new) if you find a bug, idea of improvement, etc.

## About

This project is maintained by:

- [Esteban Guido Pintos](https://github.com/epintos)
- [Gabriel Zanzotti](https://github.com/SKOLZ)
- [Matias De Santi](http://github.com/mdesanti)

and it is written by [Wolox](http://www.wolox.com.ar) under the [LICENSE](LICENSE) license.


![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)
