json.extract! dish, :id, :name, :img_url, :created_at, :updated_at
json.url dish_url(dish, format: :json)
