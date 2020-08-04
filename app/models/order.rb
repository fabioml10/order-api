class Order < ApplicationRecord
  belongs_to :state
  validates_presence_of :state_id
end
