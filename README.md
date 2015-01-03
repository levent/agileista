[![Circle CI](https://circleci.com/gh/levent/agileista.svg?style=svg)](https://circleci.com/gh/levent/agileista)

[![Build Status](https://magnum.travis-ci.com/levent/agileista.png?token=oLucmZFzPxy8fyrknDiS)](http://magnum.travis-ci.com/levent/agileista)

## AGILEISTA

### KNOWN ISSUES

 * Task Board not all cases are covered such as appropriate buttons / links appearing depending on state change
 * Test coverage is embarassingly poor
 * Contains hard coded email addresses (eg: donotreply@agileista.com / lebreeze@gmail.com)
 * Contains some hard coded server config
 * New user experience non-existent
   * Needs step by step guide to setting up and welcome to agileista stuff
 * No Documentation
 * No in app assistance etc.

### Workflow

I like to work in the develop or feature branches and then merge and deploy master so master is always deployable

We losely base our work on [http://nvie.com/posts/a-successful-git-branching-model/](http://nvie.com/posts/a-successful-git-branching-model/)

### Editing CSS

The guy who built the initial layout chose less and watchr.

To ensure the css files are compiled start the following before editing the less files.

 1. cd public/stylesheets/
 2. watchr less.watchr

### Contact

Email: [levent@purebreeze.com](mailto:levent@purebreeze.com)

Twitter: [@lebreeze](http://twitter.com/lebreeze)
