module DatabaseI18n
  module Helpers
    module TranslationsHelper
      def self.translations_tree
        obj = {}
        DatabaseI18n::Key.roots.each do |node|
          obj[node.name] = set_node(node, obj[node.name])
        end
        obj
      end

      def self.set_node(node, obj)
        if node.leaf? && node.value
          obj = node.value.body
        else
          obj = {}
          node.children.includes(value: [:translations]).each do |children|
            obj[children.name] = set_node(children, obj[children.name])
          end
        end
        obj
      end
    end
  end
end
