Rails.application.routes.draw do
  devise_for :users, path: "/",
             path_names: { sign_in: :login, sign_out: :logout, registration: :users },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  delete "/destroy/:user_id", to: "user_destroys#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :musics

  post "/likes", to: "likes#add_count"

  post "/groups/create", to: "groups#create"
  get "groups/:group_id", to: "groups#check_member"
  post "/groups/add_member", to: "groups#add_member"
  delete "/groups/destory_member/:group_id", to: "groups#destory_member"
  delete "/groups/destroy_group/:group_id", to: "groups#destroy_group"
  patch "/groups/recover_group/:group_id", to: "groups#recover_group"

  post "/playlists/:id", to: "playlists#create"
  get "/playlists/:playlist_id", to: "playlists#view"
  patch "/playlists/:playlist_id", to: "playlists#add"
  delete "/playlists/:playlist_id", to: "playlists#destroy"
end
