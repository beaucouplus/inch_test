class BuildingProfile < ApplicationRecord
  include Scopes

  NO_OVERWRITE = [:manager_name].freeze

  belongs_to :building
  has_one :current_building, class_name: 'Building', foreign_key: :current_profile_id
end
