class Order < ApplicationRecord
  belongs_to :state
  validates_presence_of :state_id

  def self.where_order_join_state(id, state_id)

    unless id === 0 && state_id === 0
      if id === 0 && state_id > 0
        query = "SELECT o.*, s.description as state_description
                  FROM orders o
                  JOIN states s ON o.state_id = s.id
                  WHERE o.state_id = #{state_id}"
      elsif id > 0 && state_id === 0
        query = "SELECT o.*, s.description as state_description
                  FROM orders o
                  JOIN states s ON o.state_id = s.id
                  WHERE o.id = #{id.to_i}"
      elsif id > 0 && state_id > 0
        query = "SELECT o.*, s.description as state_description
                  FROM orders o
                  JOIN states s ON o.state_id = s.id
                  WHERE o.id = #{id.to_i} 
                  AND o.state_id = #{state_id}"
      end
    
      ActiveRecord::Base.connection.execute(query).as_json
    else
      []
    end
  end

end
