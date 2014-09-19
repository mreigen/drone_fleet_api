# ****** Important: this file is for general setup then DO NOT add things in this file *****
#  unless this touch the whole application, do not risk to break and is strictly necessary
# Do not use spork instead install Zeus from your terminal and follow this
# http://robots.thoughtbot.com/improving-rails-boot-time-with-zeus

require 'rubygems'

require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'database_cleaner'

# removed "require 'factory_girl'" and required factory_girl_rails in Gemfile to get factories to register
# require 'factory_girl_rails'

# Need to use truncation all the time
DatabaseCleaner.strategy = :truncation

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  config.disable_monkey_patching!
  config.expose_dsl_globally = false

  # Allow FactoryGirl short syntax: create: :my_factory  - build: :my_factory
  config.include FactoryGirl::Syntax::Methods

  # Allow us to exclude groups of tests using :broken => true
  config.filter_run_excluding :broken => true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:example) do
    DatabaseCleaner.start
  end
  config.after(:example) do
    DatabaseCleaner.clean
  end
end


