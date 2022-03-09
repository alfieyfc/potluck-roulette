class CreateCuisineStyles < ActiveRecord::Migration[7.0]
  def change
    create_table :cuisine_styles do |t|
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
