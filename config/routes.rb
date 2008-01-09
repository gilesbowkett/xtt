ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users', :action => 'index'

  map.resources :statuses
  map.resources :projects, :has_many => :statuses
  map.resources :groups, :has_many => [:statuses, :projects] do |group|
    # group.resources :memberships
  end
  map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        :has_many => [:statuses]
  map.resource :session, :settings

  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil
  map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  map.login    '/login',                     :controller => 'sessions', :action => 'new'
  map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
end
