Rails.application.routes.draw do
  root to: 'dashboard#index'

  get 'number' => 'dashboard#number'
end
