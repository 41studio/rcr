Rails.application.routes.draw do
  devise_for :users
  post 'auth_user' => 'api/api_authentication#authenticate_user'
  
  namespace :api do
    resources :areas
    resources :appraisals
    resources :indicators, only: :index
  end

  resources :companies
  resources :appraisals
  resources :indicators
  resources :areas
  resources :items
end
