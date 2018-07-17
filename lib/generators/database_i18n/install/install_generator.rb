require 'rails/generators'
require 'rails/generators/migration'

module DatabaseI18n
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Add the migrations for DatabaseI18n"

      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        [:create_translation_structure, :create_translation_globalize_fields].each do |migration|
          migration_template "#{migration}.rb",
          "db/migrate/#{migration}.rb"
        end
      end

      desc "This generator creates an initializer file at config/initializers"
      def create_initializer_file
        create_file "config/initializers/database_i18n.rb", <<-FILE
          DatabaseI18n::Value.translates :body, :fallbacks_for_empty_translations => true
          DatabaseI18n::Value.globalize_accessors
        FILE
      end
    end
  end
end
