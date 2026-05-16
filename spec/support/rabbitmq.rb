# Stub RabbitMQ globally so Account callbacks don't fire real publish calls.
# $rabbitmq_exchange is set by config/initializers/031_bunny.rb at boot time.
RSpec.configure do |config|
  config.before(:each) do
    allow($rabbitmq_exchange).to receive(:publish)
  end
end
