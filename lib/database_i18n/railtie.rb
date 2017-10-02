module DatabaseI18n
  class Railtie < Rails::Railtie
    railtie_name :database_i18n
    rake_tasks do
      load 'tasks/database_i18n.rake'
    end
  end
end
