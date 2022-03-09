class AddReferenceToParticipations < ActiveRecord::Migration[7.0]
  def change
    add_reference :participations, :main_ingredient, references: :ingredient, index: true
    add_foreign_key :participations, :ingredients, column: :main_ingredient_id
  end
end
