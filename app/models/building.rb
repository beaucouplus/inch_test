class Building < ApplicationRecord
  has_many :building_profiles
  has_one :current_profile, class_name: 'BuildingProfile'
end
