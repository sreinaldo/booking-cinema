require_relative 'boot'

require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require 'sequel'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BookCinema
  class Application < Rails::Application
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # config.active_record.raise_in_transactional_callbacks = true
    #
    config.sequel.schema_format = :sql
    config.sequel.schema_dump = true
    config.sequel.load_database_tasks = :sequel
    config.sequel.logger = Logger.new($stdout)

    Sequel.extension :pg_array_ops, :pg_json_ops

    config.sequel.after_connect = proc do
      Sequel::Model.plugin :timestamps, update_on_create: true
      Sequel::Model.db.extension :pg_array
    end



    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.


    # Sequel.extension :pg_array_ops
  end
end
