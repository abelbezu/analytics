require 'rails/generators/active_record'

class Analytics::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../../../analytics/migrations', __FILE__)

  desc "Installs the proctorserv analytics migrations into a rails project."

  # InstallGenerator installs all migrations for Analytics module
  def install
    migration_template 'create_sessions.rb',       "db/migrate/create_sessions.rb"
    migration_template 'create_session_events.rb', "db/migrate/create_session_events.rb"
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end

  private
  def class_table_name
    class_name.tableize
  end
  
end
