class Tag < ApplicationRecord

  validates :name,
            presence: true,
            length: { maximum: 25 }
  has_and_belongs_to_many :ideas, foreign_key: 'tag_id'
end
