Rails.application.routes.draw do
  # resources :orders
  # resources :users

  # Paths o EndPoints para el consumo de Ordenes
  get     '/ordenes',             to: 'orders#index'
  get     '/ordenes/:id',         to: 'orders#show'
  delete  '/ordenes/:id',         to: 'orders#destroy'
  patch   '/ordenes/:id',         to: 'orders#update'
  post    '/ordenes',             to: 'orders#create'

  # Paths o EndPoints para el consumo de Usuarios
  get     '/usuarios',             to: 'users#index'
  get     '/usuarios/:id',         to: 'users#show'
  delete  '/usuarios/:id',         to: 'users#destroy'
  patch   '/usuarios/:id',         to: 'users#update'
  post    '/usuarios',             to: 'users#create'

  # Path o EndPoint especial creada para iniciar sesion, se uso el mismo recurso Usuarios
  post     '/iniciar_sesion',             to: 'users#login' 

end
