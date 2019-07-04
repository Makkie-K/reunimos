Rails.application.routes.draw do
  root 'events#top'
  #get '/login', to: 'users#login'
  #get '/signup', to: 'users#create'
  get 'users/index'
  post 'users/index', to: 'users#update', as: 'users_update'
  get 'events/show/:id', to: 'events#show', as: 'events_show'
  get 'events/create'
  post 'events/create', to: 'events#new', as: 'events_new'
  post 'rsvp_create', to: 'events#rsvp_create', as: 'rsvp_create'
  post 'events/delete/:id', to: 'events#delete', as: 'event_delete'
  post 'events/edit/:id', to: 'events#edit', as: 'event_edit'
  put 'events/edit/:id', to: 'events#update', as: 'event_update'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 

  
   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   devise_scope :user do
    get "user/:id", :to => "users/registrations#detail"
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end
end
