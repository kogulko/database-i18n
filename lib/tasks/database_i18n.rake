namespace :database_i18n do
  desc 'Load translations from yml file'
  task yml_load_translations: :environment do
    DatabaseI18n::Services::YmlLoad.load_translations
  end

  desc 'Export translations to csv file'
  task csv_export_translations: :environment do
    DatabaseI18n::Services::CsvLoad.export_and_save
  end

  desc 'Import translations from csv file'
  task :csv_import_translations, :path do |t, args|
    DatabaseI18n::Services::CsvLoad.import(args[:path])
  end


end
