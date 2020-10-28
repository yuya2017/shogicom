Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount ActionCable.server => '/cable'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: 'tops#index'
  get 'tops/:id' => 'tops#mypage'
  get 'rooms/private_message'
  get 'rooms/participating_post'
  get 'rooms/participating_tournament'
  get 'rooms/participating_community'
  get 'posts/all_content'
  get 'posts/search_post'
  get 'tournaments/all_content'
  get 'tournaments/search_tournament'
  get 'communities/all_content'
  get 'communities/search_community'
  post 'rooms/create_private_room'
  post 'tournaments/tournament_participation'
  post 'communities/community_participation'

  resources :posts, :only => [:create, :new, :show, :edit, :update, :destroy]
  resources :tournaments, :only => [:create, :new, :show, :edit, :update, :destroy]
  resources :communities, :only => [:create, :new, :show, :edit, :update, :destroy]
  resources :rooms, :only => [:show]
  resources :messages, :only => [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
