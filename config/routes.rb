App::Application.routes.draw do
  get "product/show"

  get "category/map"

  get "go/product"

  get "go/category"

  get "product/index"

  get "setting/index"

  root :to => 'home#index'

  match 'signin' => 'session#new'
  match 'signout' => 'session#destroy'
  match 'signup' => 'user#new'

  match 'auth' => 'session#create'
  match 'user/create' => 'user#create'
  
  match 'admin' => 'admin/dashboard#index'
  match 'admin/user' => 'admin/user#index'
  match 'admin/user_op' => 'admin/user#op'
  match 'admin/category' => 'admin/category#index'
  match 'admin/setting' => 'admin/setting#index'
  match 'admin/setting/new' => 'admin/setting#new'
  match 'admin/setting/create'
  match 'admin/setting_op' => 'admin/setting#op'

  match 'admin/category/sub/:id' => 'admin/category#sub'
  match 'admin/category/new' => 'admin/category#new'
  match 'admin/category/create' => 'admin/category#create'
  match 'admin/category/op' => 'admin/category#op'
  match 'admin/product' => 'admin/product#index'
  match 'admin/product/index' => 'admin/product#index'

  match 'go/product/:id' => 'go#product'
  match 'go/shop/:id' => 'go#shop'
  match 'go/category/:id' => 'go#category'
  match 'category/map' => 'category#map'
  match 'category/:id' => 'category#show'
  match 'product/:id' => 'product#show'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
