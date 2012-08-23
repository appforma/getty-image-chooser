Rails.application.routes.draw do
  match '/search_getty_images/:search' => 'getty#search_images', :as => :getty_search
end