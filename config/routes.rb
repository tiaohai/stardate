ActionController::Routing::Routes.draw do |map|
  map.resources :items
  map.resources :recurrings
  map.resources :sessions
  map.resources :users
  
  map.activity_graph 'graphs/activity', :controller=>'graphs', :action=>'activity'
    
  map.register 'register/:year/:month/:day/:period',
    :controller   => 'register',
    :action       => 'index',
    :requirements => {:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year         => nil,
    :month        => nil,
    :day          => nil,
    :period       => nil
  
  map.root :controller=>'items'
  
end
