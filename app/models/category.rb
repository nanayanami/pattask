class Category < ApplicationRecord
  belongs_to :team
  has_many :posts, dependent: :destroy
  has_one_attached :image

  validates :name,presence: true

end
