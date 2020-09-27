Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :building_profiles, only: %i[update]
  resources :person_profiles, only: %i[update]
end
