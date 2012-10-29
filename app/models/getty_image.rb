class GettyImage < ActiveRecord::Base
  belongs_to :account
  
  has_attached_file :image, :styles => { :good => "750x800>"},
    :storage => :s3,
    :path => "/:class/:id/:style.:extension",
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml"
  
  
end