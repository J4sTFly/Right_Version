class Rate < ApplicationRecord
  before_save :update_avg_rate

  belongs_to :news, foreign_key: 'news_id'
  belongs_to :user, foreign_key: 'user_id'

  validates :rate, presence: true

  def update_avg_rate
    self.news.calculate_avg_rating
  end
end
