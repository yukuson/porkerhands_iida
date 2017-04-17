Rails.application.routes.draw do
  get 'porkerhands' => 'porkerhands#index'
  post 'porkerhands' => 'porkerhands#check'
end
