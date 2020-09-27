class Building < ApplicationRecord
  
  has_many :building_profiles
  belongs_to :current_profile, class_name: 'BuildingProfile', foreign_key: :current_profile_id, optional: true

  delegate :address, :zip_code, :city, :country, :manager_name, to: :current_profile

  NO_OVERWRITE = [:manager_name].freeze

  scope :with_profiles, -> { includes(:building_profiles) }

  def profiles
    building_profiles.persisted
  end
end
