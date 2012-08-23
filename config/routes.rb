Rails.application.routes.draw do
  match '/search_getty_images' => 'getty#search_images', :as => :getty_search
end