Rails.application.routes.draw do
  apipie
  devise_for :users
  post 'api/v1/auth_user' => 'api/v1/api_authentication#authenticate_user'
  post 'api/v1/register_user' => 'api/v1/user_registration#register_user'
  
  namespace :api do
    namespace :v1 do 
      resources :appraisals, :users
      resources :indicators, only: :index
      resources :companies, only: [:show, :update]
      resources :roles, only: [:index]
      resources :areas do
        resources :items 
      end
    end
  end

end
