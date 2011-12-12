GemsServer::Application.routes.draw do
  
  ### API v0 ###
  
  match "/upload"                   => "api/v0/gemcutters#create",  :via => :post
  match "/specs.4.8.gz"             => "api/v0/specs#index",        :via => :get
  match "/prerelease_specs.4.8.gz"  => "api/v0/specs#prerelease",   :via => :get
  
  ##############

  resources :rubygems, :only => :index, :path => 'gems'

  constraints :id => Patterns::ROUTE_PATTERN do
    resources :rubygems, :path => 'gems', :only => [:show]
  end

  root :to => "rubygems#index"
end
