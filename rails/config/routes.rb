StormpathSample::Application.routes.draw do

  root to: 'users#index'

  resource :session

  get 'password-reset/:sptoken' => 'password_reset_tokens#edit', as: :password_reset
  put 'password-reset/:sptoken' => 'password_reset_tokens#update', as: :update_password
  get 'password-reset' => 'password_reset_tokens#new', as: :new_password_reset
  post 'password-reset' => 'password_reset_tokens#create', as: :request_password_token

  resources :users do
    get 'verify', on: :collection
  end
end
