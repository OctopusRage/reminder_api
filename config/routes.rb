require 'api_version'

Rails.application.routes.draw do
  devise_for :users
  # mount API::Base, at: '/'
  # mount GrapeSwaggerRails::Engine => '/docs'
  #
  # get 'secure' => 'secure#index'
  # get 'secure/logout' => 'secure#logout'
  get '/' => 'static_pages#index'
  if ENV['API_SUBDOMAIN']
    subdomain_constraint = { subdomain: ENV['API_SUBDOMAIN'].split(',') }
  else
    subdomain_constraint = {}
  end

  namespace :api, path: '/', constraints: subdomain_constraint do
    scope defaults: { format: 'json' } do
      scope module: :v1, constraints: ApiVersion.new('v1', true) do
        
        resources :user, only: [:create], controller: :user
        namespace :users do
          resource :profile, only: [:show], controller: :profile
          resource :sessions, only: [:create] 
          resources :schedules, only: [:index, :create, :update, :show, :destroy]
        end
        namespace :files do
          resources :avatars, only: [:create] do
            member do
              get ':file(.:ext)', action: 'get'
            end
          end
          resources :upload, only: [:create] do
            member do
              get ':file(.:ext)', action: 'get'
            end
          end
        end

      end
    end
  end

end
