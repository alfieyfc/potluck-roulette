class AddColumnsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :room_id, :string
    add_index :events, :room_id
    add_column :events, :max_players, :integer
    add_column :events, :user_id, :integer
    add_index :events, :user_id
    add_column :events, :public, :boolean
  end
end
