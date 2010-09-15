ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |a|
    a.resources :dept_heads
    a.resources :editors
    a.resources :supervisors
    a.resources :admins
  end

  map.namespace :editor do |e|
    e.resources :classrooms
    e.resources :pairs
    e.resources :charge_cards
  end

  map.namespace :dept_head do |d|
    d.resources :teaching_places
    d.resources :disciplines
    d.resources :specialities
  end

  map.namespace :supervisor do |s|
    s.resources :faculties
    s.resources :departments
    s.resources :classrooms
    s.resources :lecturers
  end

  map.namespace :timetable do |t|
    t.resources :groups
    t.resources :lecturers
  end

  map.resources :classrooms
  
  map.admin_root '/admin/departments', :controller => 'admin/departments'
  map.editor_root '/editor/classrooms', :controller => 'editor/classrooms'
  map.supervisor_root '/supervisor/lecturers', :controller => 'supervisor/lecturers'
  map.dept_head_root '/dept_head/lecturers', :controller => 'dept_head/teaching_places'

  map.devise_for :admin, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  map.new_admin_session '/admin/login', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
  map.admin_session '/admin/login', :controller => 'sessions', :action => 'create', :conditions => { :method => :post }
  map.destroy_admin_session '/admin/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }

  map.devise_for :editor, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  map.new_editor_session '/editor/login', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
  map.editor_session '/editor/login', :controller => 'sessions', :action => 'create', :conditions => { :method => :post }
  map.destroy_editor_session '/editor/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }

  map.devise_for :supervisor, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  map.new_supervisor_session '/supervisor/login', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
  map.supervisor_session '/supervisor/login', :controller => 'sessions', :action => 'create', :conditions => { :method => :post }
  map.destroy_supervisor_session '/supervisor/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }

  map.devise_for :dept_head, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  map.new_dept_head_session '/dept_head/login', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
  map.dept_head_session '/dept_head/login', :controller => 'sessions', :action => 'create', :conditions => { :method => :post }
  map.destroy_dept_head_session '/dept_head/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }

  map.root :controller => "timetable/groups"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
