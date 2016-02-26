Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  
  devise_scope :user do
    get '/login', :to => 'users/sessions#new', :as => :login
    #post '/users/create', :to => 'users/sessions#create', :as => :user_session
    get '/logout', :to => 'users/sessions#destroy', :as => :logout
    get '/myprofile', :to => 'users#my_profile', :as => :myprofile
  end

  root :to => 'pins#index'
  #authenticate :user do
  #  root :to => 'dashboard#index'
  #end
  
    get 'places/index'

  devise_for :users, :controllers => { :sessions => 'users/sessions', :registrations => 'users/registrations' }

  resources :searches, :only => [:index]

  resources :users do
    collection do
      get :autocomplete_user
      get :tag
    end
    resources :comments
  end

  resources :conversations do
    resources :messages
  end

  resources :pins do
    collection do
      get :autocomplete_pin_title
      get :tag
    end
  end
  resources :tags

  resources :places

  match 'dashboard' => 'dashboard#index', via: :get

  match 'pins/:pin_id/conversations/:c_id' => 'conversations#show_pin_conversation', via: :get

  match 'pins/new/:type' => 'pins#new', via: :get

  match 'pins/:id/new/:type' => 'pins#new', :as => 'new_sub_pin', via: :get
  match 'pins/:id/support' => 'pins#support', via: :post
  match 'pins/:id/set_status' => 'pins#set_status', via: :post
  match 'pins/:id/map_for_pin' => 'pins#map_for_pin', via: :get
  match 'pins/:id/show_manager_list' => 'pins#show_manager_list', :as => 'show_manager_list', via: :get
  match 'pins/:id/edit_manager_list' => 'pins#edit_manager_list', via: :get

  match 'pins/:id/conversation/:conversation_id' => 'conversation#show', via: :get

  match 'pins/:id/new_file' => 'pins#new_file', via: :put

  put 'pins/:id/like' => 'pins#like', :as => 'like_pin'
  
end
