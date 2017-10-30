Rails.application.routes.draw do
  get 'game',  to: 'words#game'
  get 'score', to: 'words#score'
  get '/',     to: 'words#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
