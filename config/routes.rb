Rails.application.routes.draw do
  match '/search_getty_images/:search' => 'getty#search_images', :as => :getty_search
  match '/download_getty_images/:image_id' => 'getty#download_image', :as => :getty_download
end