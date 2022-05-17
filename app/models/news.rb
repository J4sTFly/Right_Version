class News < ApplicationRecord
  has_one_attached :preview
  has_many_attached :related_images

  enum available_to: {
    nobody: 0,
    authenticated: 1,
    everyone: 2
  }

  enum status: {
    archived: 0,
    published: 1
  }

  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  belongs_to :author, model_name => "User" # , foreign_key: 'news_id'
  has_many :tags, foreign_key: 'news_id'

end
