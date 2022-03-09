class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :tags, array: true, default: [], using: "ARRAY[tags]::STRING[]"

      t.timestamps
    end
  end
end
