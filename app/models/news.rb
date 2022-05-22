class News < ApplicationRecord
  has_one_attached :preview
  has_many_attached :related_images

  #validates :title, presence: true, blank: false, length: { minimum: 4, maximum: 128}

  enum available_to: {
    nobody: 0,
    authorized: 1,
    everyone: 2
  }, _prefix: 'available_to'

  enum status: {
    archived: 0,
    published: 1
  }

  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_and_belongs_to_many :tags, optional: true
  belongs_to :author, :class_name => 'User', foreign_key: 'author_id'
  belongs_to :category

  scope :authorized, -> { where("available_to = 1 OR available_to = 2") }
  scope :unauthorized, -> { where("available_to = 2") }
  scope :unapproved, -> { where(approved: false) }

  scope :by_category, -> (category) { where(category: category, published: 1) }
  scope :by_tags, -> (*tags) { sort_by_tags }
  scope :by_author, -> (author) { where(author: author, published: 1) }
  scope :by_rate, -> { order(:avg_rate) }

  def calculate_avg_rating
    self.avg_rate = self.rates.average(:rate)
  end

  def self.sort_by_tags(*tags)
    queryset = tags[0].news
    tags.each do |tag|
      queryset = queryset || tag.news
    end
    queryset
  end

  def approve
    self.approved = true
    self.published!
  end
end
