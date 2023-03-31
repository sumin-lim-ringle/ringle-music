Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :musics

  get "/user_playlists/:user_id", to: "user_playlists#index"
  post "/user_playlists/create", to: "user_playlists#create"
  post "/user_playlists/create_all", to: "user_playlists#createAll"
  delete "/user_playlists/destroy/:user_id/:music_id",
         to: "user_playlists#destroy"
  delete "/user_playlists/destroy_all/:user_id/:musics_id",
         to: "user_playlists#destroyAll"

  post "/groups/create", to: "groups#create"
  post "/group_playlists/create", to: "group_playlists#create"
end
