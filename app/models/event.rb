class Event < ApplicationRecord
  has_many :dishes
  belongs_to :user
end
