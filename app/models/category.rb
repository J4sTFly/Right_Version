class Category < ApplicationRecord
  before_save :capitalize_name
  has_many :news, foreign_key: 'news_id'

  validates :name, presence: true

  def capitalize_name
    self.name = self.name.capitalize
  end
end
