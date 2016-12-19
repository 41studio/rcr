Rails.application.routes.draw do
  apipie
  devise_for :users
  post 'api/v1/auth_user' => 'api/v1/api_authentication#authenticate_user'
  
  namespace :api do
    namespace :v1 do 
      resources :areas
      resources :appraisals
      resources :indicators, only: :index
    end
  end

  resources :companies
  resources :appraisals
  resources :items
end
