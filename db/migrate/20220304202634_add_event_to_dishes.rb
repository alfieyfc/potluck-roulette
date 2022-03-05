class AddEventToDishes < ActiveRecord::Migration[7.0]
  def change
    add_column :dishes, :event_id, :integer
    add_index :dishes, :event_id
  end
end
