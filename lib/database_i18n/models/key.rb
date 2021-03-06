require 'awesome_nested_set'

module DatabaseI18n
  class Key < ::ActiveRecord::Base
    self.table_name = 'translation_keys'

    acts_as_nested_set dependent: :destroy, counter_cache: :children_count

    has_one :value, class_name: 'DatabaseI18n::Value', dependent: :destroy

    def path
      self_and_ancestors.pluck(:name).join('.')
    end
  end
end
