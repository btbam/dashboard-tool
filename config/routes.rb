Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'adjuster_dashboard#index'

  mount DashboardPlatform::API => "/api"

  mount NagiosMonitoring => "/monitoring"

  mount DashboardAlerts::API => "/monitoring"

  # ActiveAdmin.routes(self)

  devise_for :users,
    :path_names => {:sign_out => "force_logout"},
    :controllers => {
      :registrations => "users/registrations",
      :sessions => "users/sessions"
    }

  devise_scope :user do
    get "activate", to: "users/sessions#activate"
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'    
    put 'users/:id' => 'users/registrations#update', :as => 'user_registration'
  end

  # Allow us to find claims by system
  resources :claims, param: 'claims_system/:claims_id', only:[:index, :show] do
    member do
      get 'notes'
    end
  end

  get "/claims/:claims_id", to: "claims#show"
  get "/upgrade" => "pages#upgrade"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
