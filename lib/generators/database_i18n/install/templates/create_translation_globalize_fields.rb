class CreateTranslationGlobalizeFields < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        DatabaseI18n::Value.create_translation_table!({body: :string}, migrate_data: false)
      end

      dir.down do
        DatabaseI18n::Value.drop_translation_table!
      end
    end
  end
end
