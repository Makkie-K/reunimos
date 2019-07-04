class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         password_length: 6..20
  validates :name, presence: true, length: { maximum: 20 }

  enum permission: { admin: 0, creator: 1, user: 2 }
end
