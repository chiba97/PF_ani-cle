Rails.application.routes.draw do

  namespace :admin do
    get 'users/index'
    get 'users/show'
    get 'users/edit'
  end
  namespace :user do
    get 'users/show'
    get 'users/edit'
    get 'users/unsubscribe'
  end
  namespace :user do
    get 'posts/new'
    get 'posts/index'
    get 'posts/show'
    get 'posts/edit'
  end
  namespace :user do
    get 'homes/top'
    get 'homes/about'
  end
  # デバイスUser側
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "user/registrations",
    sessions: "user/sessions"
  }

  # デバイスAdmin側
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  # Admin側ルーティング
  namespace :admin do
    resources :users, except: [:new, :create, :destroy]
    get "searches" => "searches#search"
  end

  # User側ルーティング
  scope module: :user do
  root to: "homes#top"
  get "/about" => "homes#about"
  get "searches" => "searches#search"
  resources :rooms, only: [:show, :create]
  resources :messages, only: [:create]

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    member do
      get  "follows"
      get "followers"
      get "favorites"
      get "unsubscribe"
      patch "withdraw"
    end
  end

  resources :notifications, only: [:index] do
    collection do
      delete "destroy_all"
    end
  end
  end

end
