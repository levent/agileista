[![Circle CI](https://circleci.com/gh/levent/agileista.svg?style=svg)](https://circleci.com/gh/levent/agileista)

## AGILEISTA

### Prerequisites

1. PostgreSQL (9.1.x or 9.2.x)
2. Elastic Search (0.9.x)
3. [Streaming server](https://github.com/agileista/pubsub-server)

### Installation

```
git clone https://github.com/agileista/agileista
cp config/database.yml.example config/database.yml
cp config/application.yml.example config/application.yml
./bin/rake db:create
./bin/rake db:create RAILS_ENV=test
./bin/rake db:migrate
./bin/rspec # All tests should pass
```

Currently the app is expecting to run on app.agileista.local in dev mode
Edit /etc/hosts and add

```
127.0.0.1 app.agileista.local
```

### Contact

Email: [levent@purebreeze.com](mailto:levent@purebreeze.com)

Twitter: [@lebreeze](http://twitter.com/lebreeze)
