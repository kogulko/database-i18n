namespace :database_i18n do
  desc 'Load translations from yml file'
  task load_translations: :environment do
    DatabaseI18n::Services::YmlLoad.load_translations
  end
end
