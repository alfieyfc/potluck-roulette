class CreateDishesUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :dishes_users do |t|
      t.integer :user_id
      t.integer :dish_id
      t.timestamps
    end
  end
end
