class AddColumnsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :room_id, :string
    add_index :events, :room_id
    add_column :events, :max_players, :integer
    add_column :events, :public, :boolean

    add_reference :events, :owner, references: :users, index: true
    add_foreign_key :events, :users, column: :owner_id
  end
end
