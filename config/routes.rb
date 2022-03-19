Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'public#home'

  get 'public/home'

  devise_for :users, path: 'users', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }, skip: [:registrations]

  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  resources :accounts, only: [:new, :create, :show, :index, :edit, :update, :destroy] do
    member do
      patch :refresh
    end
    collection do
      patch :refresh_current
    end
  end

  resources :strategies, only: [:index] do
    resources :user_strategies, only: [:new, :edit, :show]
    collection do
      get :favourites
    end
  end

  resources :user_strategies, only: [:create, :update] do
    resources :activities, only: [] do
      collection do
        get    :delete
        delete :destroy
      end
    end
  end

  resources :charts, only: [:index] do
    collection do
      get :config, action: :charts_config, defaults: { format: 'json' }
      get :symbols, defaults: { format: 'json' }
      get :search, defaults: { format: 'json' }
      get :history, defaults: { format: 'json' }
      get :marks, defaults: { format: 'json' }
      get :timescale_marks, defaults: { format: 'json' }
      get :time, defaults: { format: 'json' }
      get :quotes, defaults: { format: 'json' }
    end
  end
end
