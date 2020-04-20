Rails.application.routes.draw do
  
  scope module: :v1 do
    resources :quizzes, defaults: { format: :json}
    resources :questions, defaults: {format: :json}
    resources :answers, defaults: {format: :json}
    resources :active_quizzes,  defaults: {format: :json}
    resources :groups, defaults: {format: :json}
    resources :reports, defaults: {format: :json}

    get 'evaluations/:pin/quiz' => 'evaluations#quiz'
    post 'evaluations/:pin/quiz' => 'evaluations#assess'
    get 'evaluations/:pin' => 'evaluations#show'

    post 'signup', to: 'users#create'
    get 'users/:id', to: 'users#show'
    put 'users/:id', to: 'users#update'
    post 'login', to: 'authentication#authenticate'
  end
end
