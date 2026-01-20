class Post < ApplicationRecord
  belongs_to :category
  belongs_to :team
  belongs_to :user
  has_rich_text :content
  has_many :comments, dependent: :destroy
end
