Rails.application.routes.draw do
  mount ArticleAPI::API => "/"
  mount CommentAPI::API => "/"
  

  resources :articles do
    resources :comments
  end
  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
