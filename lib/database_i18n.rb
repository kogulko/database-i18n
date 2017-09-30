require "database_i18n/version"
Gem.loaded_specs['database_i18n'].dependencies.each do |d|
 require d.name
end
module DatabaseI18n
  # Your code goes here...
end
