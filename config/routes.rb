Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :orders, only: [:index, :show, :new, :create, :update, :edit] do
        # collection do
        #   post 'login'
        #   patch 'change'
        # end
      end
    end
  end
end
