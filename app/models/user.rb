class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable

  # Foreign keys
  has_many :games, through: :logs
  has_many :logs
end
