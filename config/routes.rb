ActionController::Routing::Routes.draw do |map|
  map.root :controller=>'docs', :action=>'index'
  map.resources :docs
  map.resources :indexer
end