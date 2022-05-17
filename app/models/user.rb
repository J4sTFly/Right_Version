class User < ApplicationRecord
  has_one_attached :avatar

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         jwt_revocation_strategy: :JwtDenylist

  enum role: {
    user: 0,
    correspondent: 1,
    admin: 2,
    borov: 3
  }

  validates_presence_of :password_confirmation

  validates :username,
            uniqueness: true,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            uniqueness: true,
            presence: true,
            length: { maximum: 255 },
            format: { with: Devise.email_regexp }

  #validates :phone,
  #         numericality: true,
  #         length: {maximum: 15}

  has_many :news, foreign_key: 'user_id'
  has_many :rates, dependent: :nullify
  has_many :comments, dependent: :nullify

end
