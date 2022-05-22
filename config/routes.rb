Rails.application.routes.draw do
  # admin
  resources :admin, only: %i[destroy show index]

  resources :news do
    get '/pages/:page', to: 'news#index', on: :collection
  end

  as :user do
    post '/signup', to: 'users/registrations#create'
    put "/update_password" => "users/registrations#update_password"
  end

  devise_for :user, path: '', path_names: {
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
