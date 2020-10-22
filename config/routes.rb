Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount ActionCable.server => '/cable'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: 'tops#index'
  get 'tops/message'
  get 'tops/private_message'
  get 'tops/participating_post'
  get 'tops/participating_tournament'
  get 'tops/participating_community'
  get 'tops/:id' => 'tops#mypage'
  get 'posts/all_content'
  get 'tournaments/all_content'
  get 'communities/all_content'
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
