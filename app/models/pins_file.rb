class PinsFile < ApplicationRecord
  belongs_to :user
  belongs_to :pin
  
  mount_uploader :file, FileUploader
end
