Rails.application.routes.draw do
  resources :results
  resources :questions
  
  post '/line/callback', to: 'line_bot#callback'
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "questions#index"
end
