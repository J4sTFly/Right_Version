class Comment < ApplicationRecord
  belongs_to :news, foreign_key: 'news_id'
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :parent_comment, class_name: "Comment", foreign_key: "parent_comment_id", optional: true
  has_many :comments, dependent: :destroy, foreign_key: 'parent_comment_id'

  validates :body, presence: true, length: { minimum: 1, maximum: 55 }
end
