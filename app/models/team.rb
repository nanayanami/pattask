class Team < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :posts, through: :categories

  validates :name,presence: true
end
