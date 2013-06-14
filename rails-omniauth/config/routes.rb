RailsOmniauth::Application.routes.draw do
  root :to => "sessions#new"
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  resource :session
  resource :users, only: [:new, :create]
end
