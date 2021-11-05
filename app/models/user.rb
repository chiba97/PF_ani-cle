class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :pet, length: {maximum: 20}
  validates :introduction, length: {maximum: 50}
  
  attachment :profile_image
end
