[![Build Status](https://travis-ci.org/levent/agileista.svg)](https://travis-ci.org/levent/agileista)
[![Code Climate](https://codeclimate.com/github/levent/agileista/badges/gpa.svg)](https://codeclimate.com/github/levent/agileista)
[![Coverage Status](https://coveralls.io/repos/levent/agileista/badge.svg?branch=master)](https://coveralls.io/r/levent/agileista?branch=master)

## AGILEISTA

Online collaboration for distributed Scrum teams.

* An ordered backlog
* User stories with acceptance criteria
* Story points
* Sprint planning
* Velocity calculations
* Simple horizon planning
* Pair programming support
* Task board
* Burn charts
* No hour tracking on tasks
* Slack integration
* HipChat integration
* Planning poker

### Background

I have been working on this on and off for several years. It has been running in [production](https://app.agileista.com) and I have used it in every job since Eben and I first came up with the concept in 2007.
The repo is full of legacy code that needs to be cleaned up.
There is a lot of [repetition](http://en.wikipedia.org/wiki/Don't_repeat_yourself) and the javascript is all over the place.
I have included the full git history which contains application secrets and capistrano recipes but none of the credentials are valid anymore.

Enjoy using it! It's less confusing than JIRA and more suited to Scrum than Trello.

### Prerequisites

1. PostgreSQL (9.1.x or 9.2.x)
2. Elastic Search (0.9.x)
3. [Streaming server](https://github.com/levent/pubsub-server)

### Dev mode installation

```
git clone https://github.com/levent/agileista
cp config/database.yml.example config/database.yml
cp config/application.yml.example config/application.yml
./bin/rake db:create
./bin/rake db:create RAILS_ENV=test
./bin/rake db:migrate
./bin/test # All tests should pass
./bin/rails server
```

Currently the app is expecting to run on app.agileista.local in dev mode
Edit /etc/hosts and add

```
127.0.0.1 app.agileista.local
```

### Hosted version

Sign up at https://app.agileista.com

This may include more *pro* features in the future.

### License

Please see [LICENSE](https://github.com/levent/agileista/blob/master/LICENSE) for licensing details.

### Contact

Email: [levent@purebreeze.com](mailto:levent@purebreeze.com)

Twitter: [@lebreeze](http://twitter.com/lebreeze)
