class Game < ApplicationRecord
  has_many :users, through: :logs
  has_many :logs
end
