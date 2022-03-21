# OandaTrader

This is a UI to be able to interact with the user account and strategies.

![oanda_trader_ui](https://user-images.githubusercontent.com/3071529/158765544-0003de61-0f78-4426-8298-3cbc9857c03a.jpg)

## Usage

### Development

Start the service

    bin/rails s

Start the workers

    WORKERS=StrategyActivityJob,StrategyWarningJob,StrategyProgressJob,StrategyUpdateJob bundle exec rake sneakers:run

### Backtesting

Start the service

    RAILS_ENV=backtest bin/rails s --pid `pwd`/tmp/pids/server_backtest.pid

Start the workers

    RAILS_ENV=backtest WORKERS=StrategyActivityJob,StrategyWarningJob,StrategyProgressJob,StrategyUpdateJob bundle exec rake sneakers:run

## Developer Setup

Create the database

```ruby
bin/rails db:create
RAILS_ENV=backtest bin/rails db:create
```

Migrate the database

```ruby
bin/rails db:migrate
RAILS_ENV=backtest bin/rails db:migrate
```

Setup the database with the required authenticated users

```ruby
bin/rails db:seed
RAILS_ENV=backtest bin/rails db:seed
```
