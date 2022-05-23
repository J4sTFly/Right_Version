Rails.application.routes.draw do
  resources :admins
  resources :categories
  resources :comments
  resources :rates
  resources :tags

  resources :news do
    get '/pages/:page', to: 'news#index', on: :collection
    post '/approve', to: 'news#approve'
    post '/sort_by', to: 'news#sort_by'
  end

  as :user do
    post '/signup', to: 'users/registrations#create'
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
