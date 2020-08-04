require 'simplecov'
SimpleCov.start
require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do

  let(:host) {"http://localhost:3000/api/v1/"}
  let(:json) {JSON.parse(response.body)}

  describe "GET order#index" do

    it "responds with 200" do
      get("#{host}/orders")
      expect(response).to have_http_status(:ok)
    end

    it "returns an array object" do
      get("#{host}/orders")
      expect(json).to be_an_instance_of(Array)
    end

    it "returns all orders" do
      order1 = Order.create(state_id: 1)
      order2 = Order.create(state_id: 1)
      get("#{host}/orders")
      expect(json.length).to be > 1
    end

  end

  describe "GET orders#show" do

    it "responds with 200 as an array object" do
      order = Order.create(state_id: 1)
      get("#{host}/orders/#{order.id}")
      expect(response).to have_http_status(:ok)
      expect(json).to be_an_instance_of(Array)
    end

    it "order by number 404" do
      get("#{host}/orders/0")
      expect(response).to have_http_status(:not_found)
    end

    it "order by state 404" do
      get("#{host}/orders/state?state_id=0")
      expect(response).to have_http_status(:not_found)
    end

  end

  describe "POST orders#create" do

    it 'responds with 201' do
      order = { order: { state_id: 1 } }
      post "#{host}/orders", :params => order.to_json, :headers => { "Content-Type": "application/json" }
      expect(response).to have_http_status(:created)
    end

    it 'responds with 400' do
      order = { order: { state_id: 2 } }
      post "#{host}/users", :params => order.to_json, :headers => { "Content-Type": "application/json" }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PATCH order#edit' do

    it 'should change state' do
      order = Order.create(state_id: 1)
      new_order_state = { order: { state_id: 2 }}
      patch "#{host}/orders/#{order.id}", :params => new_order_state.to_json, :headers => { "Content-Type": "application/json" }
      expect(response).to have_http_status(:ok)
    end

    it 'should not change state' do
      order = Order.create(state_id: 1)
      new_order_state = { order: { state_id: 3 }}
      patch "#{host}/orders/#{order.id}", :params => new_order_state.to_json, :headers => { "Content-Type": "application/json" }
      expect(response).to have_http_status(:bad_request)
    end

  end

end
