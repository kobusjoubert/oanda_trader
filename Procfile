web: bundle exec puma -C config/puma.rb
worker: WORKERS=StrategyActivityJob,StrategyWarningJob,StrategyProgressJob,StrategyUpdateJob bundle exec rake sneakers:run
