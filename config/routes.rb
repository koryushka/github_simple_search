# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get 'welcome', to: 'search#index'
  root to: 'repo_search#search'
  get 'callback', to: 'github_sessions#callback'
  delete 'logout', to: 'github_sessions#logout'
end
