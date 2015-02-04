[![Circle CI](https://circleci.com/gh/agileista/agileista.svg?style=svg)](https://circleci.com/gh/agileista/agileista)
[![Code Climate](https://codeclimate.com/github/agileista/agileista/badges/gpa.svg)](https://codeclimate.com/github/agileista/agileista)

## AGILEISTA

I've been working on this for years. I have used it in [production](https://app.agileista.com) at most of my jobs since Eben and I first came up with the idea in 2007.
The repo is full of a lot of terrible legacy code that needs to be cleaned up.
There is a lot of [repetition](http://en.wikipedia.org/wiki/Don't_repeat_yourself).
I have included the full git history but may need to rewrite the history to remove large objects.
The history contains application secrets and capistrano recipes but none of the credentials are valid anymore.

### Prerequisites

1. PostgreSQL (9.1.x or 9.2.x)
2. Elastic Search (0.9.x)
3. [Streaming server](https://github.com/agileista/pubsub-server)

### Dev mode installation

```
git clone https://github.com/agileista/agileista
cp config/database.yml.example config/database.yml
cp config/application.yml.example config/application.yml
./bin/rake db:create
./bin/rake db:create RAILS_ENV=test
./bin/rake db:migrate
./bin/rspec # All tests should pass
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

Please see [LICENSE](https://github.com/agileista/agileista/blob/master/LICENSE) for licensing details.

### Contact

Email: [levent@purebreeze.com](mailto:levent@purebreeze.com)

Twitter: [@lebreeze](http://twitter.com/lebreeze)
