source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.5'

gem 'dotenv-rails', groups: [:development, :backtest, :test], require: 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.19'
gem 'bunny', '~> 2.9'
gem 'sneakers', '~> 2.7'
gem 'puma', '~> 3.6'
gem 'rack-timeout', '~> 0.4'
gem 'groupdate', '~> 3.1'

gem 'sass-rails', '~> 5.0'
gem 'haml-rails', '~> 1.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'font-awesome-rails', '~> 4.7'
gem 'bootstrap', '~> 4.0.0'
gem 'twitter-bootstrap-rails-confirm', '~> 1.0'
gem 'kaminari', '~> 0.17'
gem 'chartkick', '~> 2.2'

# You will need to request access to TradingView's [https://www.tradingview.com] private charting library
# [https://www.tradingview.com/HTML5-stock-forex-bitcoin-charting-library/?feature=charting-and-trading-platform] and create your own private
# tv_chart_rails_private gem to be included in your project to expose [http://localhost:3000/charts] a charting interface
# [https://trading-terminal.tradingview.com] which will be used to plot your trades on while backtesting or live trading.
#
# gem 'tv_chart_rails_private', '2.0.4', git: 'https://github.com/kobusjoubert/tv_chart_rails_private.git', branch: 'unstable'

gem 'gravatar_image_tag', '~> 1.2'
gem 'non-stupid-digest-assets', '~> 1.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

gem 'attr_encrypted', '~> 3.1'
gem 'devise', '~> 4.2'
gem 'devise_invitable', '~> 1.7'
# gem 'cancancan', '~> 1.15'
gem 'http-exceptions_parser', '~> 0.1'
gem 'oanda_api_v20', '~> 2.1'
gem 'oanda_service_api', '0.1.11', git: 'https://github.com/kobusjoubert/oanda_service_api.git'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.3'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :backtest, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
end

group :development, :backtest do
  gem 'listen', '~> 3.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.5'
end

group :backtest do
  gem 'oanda_api_v20_backtest', '2.0.46', git: 'git@github.com:kobusjoubert/oanda_api_v20_backtest.git'
end
