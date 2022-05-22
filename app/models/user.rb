class User < ApplicationRecord
  has_one_attached :avatar
  include Devise::JWT::RevocationStrategies::JTIMatcher

  validates_presence_of :password_confirmation, if: :password_required?

  validates :username,
            uniqueness: true,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            uniqueness: true,
            presence: true,
            length: { maximum: 255 },
            format: { with: Devise.email_regexp }

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         jwt_revocation_strategy: self

  enum role: {
    user: 0,
    correspondent: 1,
    admin: 2,
    borov: 3
  }

  #validates :phone,
  #         numericality: true,
  #         length: {maximum: 15}

  has_many :news, foreign_key: 'author_id'
  has_many :rates, dependent: :nullify
  has_many :comments, dependent: :nullify
end
