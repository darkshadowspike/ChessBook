# ChessBook Application

Author: Andrew Matos

A Web Application that shares some Facebook functionality with an online Chess game integrated.


## Technology used

- Ruby 2.6.4

- Rails 5.2.4

- PostgreSQL 12.2

- Javascript/EMCS6

- HTML5

- CSS6

## Main features

	-CRUD users, posts, comments, user relationship, messages using PostgreSQL rails framework models and controllers

	-Interactive and responsive desktop UI made using only vanilla JS and CSS

	-DOM elements update with ajax for a more responsive experience

	-Image and video uploader using Rails Active Storage blobs and Dropbox-activeStorage Gem

	-Account confirmation and password reset mail system made with Rails Mailer and Sendgrid API

	-Realtime chats boxes and Chessgames with WebSocket protocol using Rails Action Cable and Redis

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

