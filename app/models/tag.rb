class Tag < ApplicationRecord

  validates :name,
            presence: true,
            length: { maximum: 50 }
  has_and_belongs_to_many :news, foreign_key: 'news_id'
end
