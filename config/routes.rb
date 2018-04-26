BetterRailsDebugger::Engine.routes.draw do
  # NEW
  resources :analysis_groups

  resources :group_instances do
    member do
      get 'objects'
      get 'tracer'
      get 'code'
      get 'backtrace'
    end
  end

  # OLD
  root 'analysis_groups#index'

  resources :memory, only: [:index, :show] do
    member do
      get 'analyze'
    end
  end

end
