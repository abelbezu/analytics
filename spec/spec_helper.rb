require 'rails'
require 'sidekiq'
require 'active_record'

require 'analytics'
require 'analytics/migrations/create_sessions'
require 'analytics/migrations/create_session_events'

Rails.env = "test"

RSpec.configure do |config|
  config.order = "random"

  config.before(:all) do
    connections = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'database.yml'))
    ActiveRecord::Base.establish_connection connections[Rails.env]
    CreateSessions.migrate :up
    CreateSessionEvents.migrate :up
  end

  config.after(:all) do
    CreateSessions.migrate :down
    CreateSessionEvents.migrate :down
  end
end