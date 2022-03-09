class AddReferenceToParticipation < ActiveRecord::Migration[7.0]
  def change
    add_reference :participations, :cuisine_style, references: :cuisine_style, index: true
    add_foreign_key :participations, :cuisine_styles, column: :cuisine_style_id
  end
end
