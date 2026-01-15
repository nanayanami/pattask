class Post < ApplicationRecord
  belongs_to :category
  belongs_to :team
  has_rich_text :content
end
