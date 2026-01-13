class Team < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :posts, through: :categories
end
