Rails.application.routes.draw do
  # admin
  resources :admin, only: %i[destroy show index]
  get '/find_by_role/', to: 'admin#find_by_role'
  #

  # idea
  resources :idea
  get '/show_all_ideas', to: 'idea#show_all_ideas'
  put '/update_status/:id/:access', to: 'idea#update_status'
  put '/add_investor_idea/:id', to: 'idea#add_investor_to_idea'
  #

  # comment
  resources :comment, only: %i[update destroy show]
  post '/create_comment/:idea_id', to: 'comment#create'
  post '/create_under_comment/:id', to: 'comment#create_under_comment'
  get '/show_comment_idea/:idea_id', to: 'comment#show_comment_to_idea'
  get '/show_under_comment/:id', to: 'comment#show_under_comment'
  #

  # tag
  resources :tag, only: %i[update destroy show]
  post '/create_tags/:idea_id', to: 'tag#create'
  get '/get_tags/:q', to: 'tag#get_tags'
  get '/get_tags_idea/:idea_id', to: 'tag#index'
  #

  # dislike
  post '/add_dislike/:idea_id', to: 'dislike#create'
  delete '/delete_dislike/:idea_id', to: 'dislike#destroy'
  get '/get_dislike_idea/:idea_id', to: 'dislike#get_amount_dislikes'
  #

  # like
  post '/add_like/:idea_id', to: 'like#create'
  delete '/delete_like/:idea_id', to: 'like#destroy'
  get '/get_like_idea/:idea_id', to: 'like#get_amount_likes'
  #

  # rate
  post '/add_rate/:idea_id', to: 'rate#create'
  delete '/delete_rate/:idea_id', to: 'rate#destroy'
  put '/update_rate/:idea_id', to: 'rate#update'
  get '/get_rate_idea/:idea_id', to: 'rate#get_rate_idea'
  #

  as :user do
    put "/update_password" => "users/registrations#update_password"
    get '/current_user', to: 'users/sessions#index'
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/password'
  }

end
