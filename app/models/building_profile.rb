class BuildingProfile < ApplicationRecord
  belongs_to :building
  belongs_to :current_building, class_name: 'Building', foreign_key: :current_profile_id, optional: true
end
