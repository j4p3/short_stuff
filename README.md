# ShortStuff

Let's light this candle

## Development

**Prerequisites**

* Erlang/Elixir
* Node.js

**Env variables**

* `DATABASE_URL`

**Steps**

1. Create database corresponding to your `DATABASE_URL`. I use `ecto://short_stuff_dev:postgres@db/short_stuff_dev` locally.
2. Install dependencies with `mix deps.get`
3. Create and migrate your database with `mix ecto.setup`
4. Install Node.js dependencies with `npm install` inside the `assets` directory
5. Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Production-like environment

**Prerequisites**

* Docker

**Steps**

1. `docker-compose up --build`
