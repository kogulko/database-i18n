module DatabaseI18n
  module Services
    module DeepFetch
      def deep_fetch(*args)
        args.reduce(self) { |hsh, k| hsh.fetch(k) { |x| yield(x) } }
      end
    end

    class YmlLoad
      attr_accessor :locale

      def self.load_translations
        if DatabaseI18n::Key.table_exists?
          ActiveRecord::Base.transaction do
            I18n.available_locales.each do |locale|
              file = Pathname.new([Rails.root, 'config', 'database_i18n', "#{locale}.yml"].join('/'))
              if file.exist?
                schema = YAML.load(ERB.new(file.read).result)

                schema.extend(DeepFetch)

                nested_translations_tree(schema, locale)
                remove_old_fields(schema, locale)

                Rails.cache.delete_matched('translations/*')
              end
            end
            remove_empty_translations
          end
        end
      end

      private

      def self.nested_translations_tree(obj, locale, parent = nil)
        obj.each do |key, value|
          if value.is_a? String
            t = parent.children.find_or_create_by(name: key)
            t.create_value unless t.value
            I18n.locale = locale
            t.value.update(body: value)
          elsif value.is_a? Hash
            if parent.nil?
              nested_translations_tree(value, locale, DatabaseI18n::Key.roots.find_or_create_by!(name: key))
            else
              nested_translations_tree(value, locale, parent.children.find_or_create_by(name: key))
            end
          end
        end
      end

      def self.remove_old_fields(schema, locale)
        leaves = DatabaseI18n::Key.leaves
        leaves.each do |leaf|
          path = leaf.self_and_ancestors.pluck(:name)
          begin schema.deep_fetch(*path)
            # Everything is OK
          rescue LocalJumpError
            translation = leaf.value.translations.find_by(locale: locale)
            next unless translation
            puts "Translation #{translation.body} on path '#{path.join('.')}'  with locale '#{locale}' was destroyed"
            translation.destroy
            remove_old_fields(schema, locale)
          end
        end
      end

      def self.remove_empty_translations
        DatabaseI18n::Key.leaves.left_joins(value: :translations).group('translation_keys.id').
          having('COUNT(translation_value_translations.translation_value_id) = 0').destroy_all
      end
    end
  end
end
