class UserTypePriviledge < ActiveRecord::Base
  belongs_to :priviledge
  belongs_to :user_type
end
