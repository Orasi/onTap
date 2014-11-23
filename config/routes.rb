LunchLearn::Application.routes.draw do

  get '/calendar' => 'events#calendar'
  resources :events, except: :index
  resources :surveys
  resources :webinars
  resources :suggestions
  resources :archive
  resources :attachments

  post 'labs/new' => 'labs#create', as: :create_template
  post 'labs/:id' => 'labs#create_lab', as: :create_lab, format: :json

  get 'labs/:id/status' => 'labs#lab_status', as: :lab_status, format: :json
  get 'labs/:id/manage' => 'labs#manage', as: :manage_lab
  post 'labs/:id/extend/:hours' => 'labs#extend_lab', as: :extend_lab
  delete 'labs' => 'labs#delete_lab', as: :delete_lab
  get 'labs/:id/rdp'    => 'labs#generate_rdp_file', as: :lab_rdp
  resources :labs

  post '/attachment/:event_id' => 'attachments#create', as: :create_attachment
  get '/download/:id' => 'attachments#download', as: :download

  resources :notifications

  post '/finalize/:id' => 'events#finalize', as: :finalize
  get '/attendee/:id' => 'attendees#change', as: :attendee
  #  resources :attendees
  # get "lunch_and_learn/create"
  # get "/tempLogin" => 'users#tempLogin'
  post '/login' => 'welcome#validate'
  post '/auth/saml/callback', to: 'welcome#validate', as: :saml_login

  get '/login' => 'welcome#login'
  get '/logout' => 'welcome#logout'
  get 'approve_attend' => 'attendees#approve_attend'
  get 'reject_attend' => 'attendees#reject_attend'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#login'

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
