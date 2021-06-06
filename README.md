# lencse/circleci-node-express

[![CircleCI](https://circleci.com/gh/lencse/circleci-node-cypress/tree/main.svg?style=svg)](https://circleci.com/gh/lencse/circleci-node-cypress/tree/main)

Docker images to run [Cypress](https://www.cypress.io/) tests on [Circle CI](https://circleci.com/).

## Features:

* Monthly rebuild to get new browser version
* Based on official [Circle CI Node.js images](https://circleci.com/developer/images/image/cimg/node)
* Autotested with Cypress sample tests

## Usage

Use it like the standard Circle CI Circle CI Node.js images and run cypress with chrome browser.

````yml
# .circleci/config.yml
version: 2.1
jobs:
  build:
    docker:
      - image: lencse/circleci-node-cypress:"14.17-chrome-91
        environment:
    steps:

      - checkout

      # Setup and build your project
      # ...

      - run:
          name: Run E2E tests
          command: `yarn bin`/cypress run --browser chrome --headless
````

## Built tags:

https://hub.docker.com/repository/docker/lencse/circleci-node-cypress/tags


