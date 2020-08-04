class Order < ApplicationRecord
  belongs_to :state, dependent: :destroy
  validates_presence_of :state
end
