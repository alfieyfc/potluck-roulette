class Event < ApplicationRecord
  has_many :dishes, dependent: :destroy
  belongs_to :owner, class_name: :User, foreign_key: :owner_id
  has_many :participations, dependent: :destroy
end
