require 'globalize'

module DatabaseI18n
  class Value < ::ActiveRecord::Base
    self.table_name = 'translation_values'

    attribute :body

    belongs_to :key, class_name: 'DatabaseI18n::Key', touch: true

    delegate :path, to: :key
  end
end
