class Order < ApplicationRecord
  belongs_to :state
  validates_presence_of :state_id

  def self.find_order_join_state(id)
    query = "SELECT o.*, s.description as state_description
    FROM orders o
    JOIN states s ON o.state_id = s.id
    WHERE o.id = #{id.to_i}"

    ActiveRecord::Base.connection.execute(query).first.as_json
  end

  def self.where_order_join_state(state_id = nil)
    if state_id
      query = "SELECT o.*, s.description as state_description
      FROM orders o
      JOIN states s ON o.state_id = s.id
      WHERE o.state_id = #{state_id}"
    else
      query = "SELECT o.*, s.description as state_description
      FROM orders o
      JOIN states s ON o.state_id = s.id"
    end
    
    ActiveRecord::Base.connection.execute(query).as_json
  end

end
