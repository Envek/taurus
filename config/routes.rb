# -*- encoding : utf-8 -*-
Taurus::Application.routes.draw do

##### Общие части #####

  concern :departments do
    get :charge_cards_form, on: :member
  end

  concern :teaching_places do
    get :training_assignments, on: :member
  end

  concern :training_assignments do
    resources :training_assignments do
      as_routes
      get :report, on: :collection
      get :join_selected, on: :collection
      get :split_by_disciplines, on: :member
      get :split_by_groups, on: :member
      get :new_charge_cards, on: :collection
      post :create_charge_cards, on: :collection
    end
  end

  concern :speciality_teaching_plans do
    get :teaching_plan_import, on: :collection
    post :teaching_plan_import, on: :collection
    get :teaching_plan, on: :member
  end

##### Отображение расписания #####

  root :to => redirect('/timetable/groups')

  namespace :timetable do
    resources :groups do
      get :qrcode, on: :member
    end
    resources :lecturers
    resources :classrooms
    root :to => redirect('/timetable/groups')
  end

##### Общее #####

post 'semesters/change' => 'application#change_current_semester'
resources :semesters, :only => [:index]
match 'help(/:page(.:format))', :controller => 'help', :action => 'show', :page => /(\w*\/?\w*)*/, :defaults => { :page => 'index' }, :as => :help

##### Редакторский раздел #####

  namespace :editor do
    root :to => redirect('/editor/groups')

    # Редактор по аудиториям
    namespace :classrooms do
      resources :classrooms
      resources :pairs
      resources :charge_cards
      resources :classrooms_sheets
      root :to => 'classrooms#index'
    end

    # Редактор по группам
    namespace :groups do
      resources :groups
      resources :pairs
      resources :classrooms
      resources :charge_cards
      root :to => 'groups#index'
    end

    # Справочные материалы
    namespace :reference do
      resources :groups
      resource :groups_list do
        resources :groups
      end
      resources :departments do as_routes end
      resources :disciplines do as_routes end
      resources :teaching_places do as_routes end
      resources :charge_cards do as_routes end
      get 'teaching_plans' => 'teaching_plans#index'
      get 'teaching_plans/:group_id' => 'teaching_plans#show'
      root :to => redirect('/editor/reference/classroom_sheets')
    end
  end

##### Раздел заведующего кафедрой #####

  get  'dept_head(/*parts)' => 'department/base#change_current_department'
  get  'department' => 'department/base#change_current_department'
  post 'department/change' => 'department/base#change_current_department'
  namespace :department, :path => '/department/:department_id', :department_id => /\d+/ do
    resources :teaching_places do
      as_routes
      record_select_routes
      get :training_assignments, on: :member
    end
    resources :disciplines do
      as_routes
      record_select_routes
    end
    resources :groups do
      as_routes
      collection do get :browse end
      member do
        post :select
        get  :teaching_plan
      end
    end
    resources :lecturers do
      as_routes
      record_select_routes
    end
    resources :charge_cards do
      as_routes
    end
    resources :specialities, concerns: [:speciality_teaching_plans] do
      as_routes
      member do
        get :add_charge_cards
        post :create_charge_cards
      end
    end
    resources :classrooms do as_routes end
    resource :charge_card_form, only: [:show, :edit, :save]
    concerns :training_assignments
    root :to => redirect {|env, req| "/department/#{req.params[:department_id]}/teaching_places" }
  end

##### Раздел деканата #####

  get  'faculty' => 'faculty/base#change_current_faculty'
  post 'faculty/change' => 'faculty/base#change_current_faculty'

  namespace :faculty, :path => '/faculty/:faculty_id', :faculty_id => /\d+/ do
    resources :specialities, concerns: [:speciality_teaching_plans] do
      member do
        post :generate_training_assignments
      end
      collection do
        post :generate_training_assignments
      end
      as_routes
    end
    resources :lecturers do as_routes end
    resources :groups do as_routes end
    resources :teaching_places do
      as_routes
      record_select_routes
    end
    resources :disciplines do
      as_routes
      record_select_routes
    end
    resources :departments, concerns: [:departments] do as_routes end
    concerns :training_assignments
    root :to => redirect('/supervisor/lecturers')
  end

##### Раздел супервайзера #####

  namespace :supervisor do
    resources :faculties do as_routes end
    resources :specialities, concerns: [:speciality_teaching_plans] do
      post :generate_training_assignments, on: :collection
      post :generate_training_assignments, on: :member
      as_routes
    end
    resources :groups do
      as_routes
      collection do get :browse end
      member do get :teaching_plan end
    end
    resources :classrooms do as_routes end
    resources :lecturers do as_routes end
    resources :teaching_places do
      as_routes
      record_select_routes
    end
    resources :charge_cards do as_routes end
    resources :disciplines do
      as_routes
      record_select_routes
    end
    resources :departments, concerns: [:departments] do as_routes end
    resources :semesters do as_routes end
    concerns :training_assignments
    root :to => redirect('/supervisor/lecturers')
  end

##### Администраторский раздел #####

  namespace :admin do
    resources :users do as_routes end
    resources :dept_heads do as_routes end
    resources :editors do as_routes end
    resources :supervisors do as_routes end
    resources :admins do as_routes end
    resources :departments do
      as_routes
      record_select_routes
    end
    resources :faculty_heads do as_routes end
    resources :faculties do
      as_routes
      record_select_routes
    end
    root :to => redirect('/admin/dept_heads')
  end

##### Аутентификация #####

  devise_for :user, :skip => [:sessions]
  devise_scope :user do
    get    'user/login' => 'devise/sessions#new',      :as => :new_user_session
    post   'user/login' => 'devise/sessions#create',    :as => :user_session
    delete 'user/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  match "/:rolename/login" => redirect("/user/login")

  match '/:controller(/:action(/:id))'

end
