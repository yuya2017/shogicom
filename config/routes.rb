Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount ActionCable.server => '/cable'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#new_guest'
  end
  root to: 'tops#index'
  get 'tops/:id' => 'tops#mypage'
  get 'rooms/private_message'
  get 'rooms/participating_post'
  get 'rooms/participating_tournament'
  get 'rooms/participating_community'
  get 'posts/search_post'
  get 'tournaments/search_tournament'
  get 'communities/search_community'
  post 'rooms/create_private_room'
  post 'tournaments/tournament_participation'
  post 'communities/community_participation'

  resources :posts
  resources :tournaments
  resources :communities
  resources :rooms, :only => [:show]
  resources :messages, :only => [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
