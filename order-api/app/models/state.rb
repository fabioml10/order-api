class State < ApplicationRecord
  has_many :orders
  validates_presence_of :description
end
