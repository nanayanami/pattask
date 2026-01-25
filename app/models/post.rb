class Post < ApplicationRecord
  belongs_to :category
  belongs_to :team
  belongs_to :user
  has_rich_text :content
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title,presence: true,length: { maximum: 50 }
  validates :content,presence: true

  enum status: { published:0,draft:1}  
  enum progress_status: { needs_attention: 0, in_progress: 1, on_track: 2 }

  PROGRESS_LABELS = {
    needs_attention: "要フォロー",
    in_progress: "対応中",
    on_track: "順調"
  }.freeze

  PROGRESS_BUTTON_CLASSES = {
    needs_attention: "btn-danger",
    in_progress: "btn-warning",
    on_track: "btn-primary"
  }.freeze

  def progress_label
    PROGRESS_LABELS[progress_status&.to_sym] || "未設定"
  end

  def progress_button_class
    PROGRESS_BUTTON_CLASSES[progress_status&.to_sym] || "btn-secondary"
  end


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
