class CreateTranslationStructure < ActiveRecord::Migration[5.1]
  def change
    create_translation_keys
    create_translation_values
  end

  def create_translation_keys
    create_table :translation_keys do |t|
      t.string :name
      t.references :parent
      t.integer :depth
      t.integer :lft
      t.integer :rgt
      t.integer :children_count, null: false, default: 0
      t.timestamps
    end

    add_index :translation_keys, :lft
    add_index :translation_keys, :rgt
    add_index :translation_keys, :name
    add_index :translation_keys, :children_count

  end

  def create_translation_values
    create_table :translation_values do |t|
      t.belongs_to :translation_key

      t.timestamps
    end
  end
end
