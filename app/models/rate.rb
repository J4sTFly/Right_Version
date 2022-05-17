class Rate < ApplicationRecord
  belongs_to :news, foreign_key: 'news_id'
  belongs_to :user, foreign_key: 'rate_id'
end
