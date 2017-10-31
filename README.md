# DatabaseI18n
## Getting started

DatabaseI18n works with Rails 5.1 onwards. You can add it to your Gemfile with:

```ruby
gem 'database_i18n', git: 'https://github.com/kogulko/database-i18n'
```

Then run `bundle install`

Next, you need to run the generator:

```console
$ rails generate database_i18n:install
```
After that, you will have generated migration and initializer files
 `config/initializers/database_i18n.rb`:
 ```ruby
DatabaseI18n::Value.translates :body, :fallbacks_for_empty_translations => true 
```
 This file contain information about column, which store translation value. So, if you want to change translation value column name in migration, you also need to change column name in initializer file.

Then run `rails db:migrate`

## Translations Import/Export
### 1. Import from yml files
 Strore your files with translations in `config/database_i18n/` folder. For example:
 `config/database_i18n/en.yml`:
 ```yaml
 test:
  hello: 'Hello!'
 ```
 Then run `rake database_i18n:yml_load_translations`. 
 ### 2. Import from csv files
 Store your translations in csv files. Use next format:

| key                  | en               | ru                 | 
|----------------------|------------------|--------------------| 
| profile.nav.settings | Profile Settings |  Настройки профиля | 
| main.header.about_us | About us         |  О нас             |

Then run `rake database_i18n:csv_import_translations[path]`, where `path` is your csv file location.
 ### 3. Export to csv csv file
 Run `rake database_i18n:csv_export_translations`. This task will create a file in the above format.
  ## Helpers
  1. You can take all your translations in JSON format. Use `DatabaseI18n::TranslationsHelper.translations_tree ` method.
  2. Also you can find translations by keys combination. For example you have such translations:
       ```yaml
     test
         hello: 'Hello!'
         my_name: 'My name is %{name}'
     ```
     Use `DatabaseI18n::TranslationsHelper.find_by_key ` method:
     ```ruby
     DatabaseI18n::TranslationsHelper.find_by_key('test.hello') #=> Hello!
     DatabaseI18n::TranslationsHelper.find_by_key('test.my_name', name: 'Alex') #=> My name is Alex
     ```
