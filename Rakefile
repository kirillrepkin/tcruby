require 'active_record'
require './db/db_conn'
require 'rake/testtask'

namespace :db do

  desc "Apply fixtures on the database"
  task :seeds do
    ActiveRecord::Base.establish_connection(db_config)
    require './db/seeds'
  end

  desc "Apply the database migration scripts"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new("db/migrate/").migrate
  end

  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Base.connection.create_database(db_config[:database])
    puts "Database created."
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Base.connection.drop_database(db_config[:database])
    puts "Database deleted."
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc 'Create the schema file for database'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = "db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[7.0]
  def self.up
  end
  def self.down
  end
end
EOF
    end
    puts "Migration #{path} created"
    abort
  end
end

namespace :test do
  desc "Run unit tests"
  task :unit do
    FileList['test/*.rb'].each { |file| system ("ruby " + file) }
  end
end