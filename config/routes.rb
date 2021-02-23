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
    post 'users/password_change' => 'users/registrations#password_change'
  end
  root to: 'tops#index'
  get 'tops/:id' => 'tops#mypage'
  get 'rooms/private_message'
  get 'rooms/participating_post'
  get 'rooms/participating_tournament'
  get 'rooms/participating_community'
  get 'rooms/:id/post' => 'rooms#post_show'
  get 'rooms/:id/tournament' => 'rooms#tournament_show'
  get 'rooms/:id/community' => 'rooms#community_show'
  get 'rooms/:id/private' => 'rooms#private_show'
  get 'posts/search_post'
  get 'tournaments/search_tournament'
  get 'communities/search_community'
  post 'rooms/create_private_room'
  post 'tournaments/tournament_participation'
  post 'communities/community_participation'
  post 'tournaments/tournament_exit'
  post 'communities/community_exit'
  get 'healthchecks/index'

  namespace :api, format: 'json' do
    resources :posts
    resources :tournaments
    get 'users' => 'users#index'
    get 'users/user_signed_in'
    get 'tournament_users' => 'tournament_users#index'
  end

  resources :posts
  resources :tournaments
  resources :communities
  resources :messages, :only => [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
