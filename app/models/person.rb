class Person < ApplicationRecord
  has_many :person_profiles
  belongs_to :current_profile, class_name: 'PersonProfile', foreign_key: :current_profile_id, optional: true

  delegate :address, :email, :home_phone_number, :mobile_phone_number, :firstname, :lastname, to: :current_profile

  NO_OVERWRITE = %i[email home_phone_number mobile_phone_number address].freeze

  scope :with_profiles, -> { includes(:person_profiles) }

  def profiles
    person_profiles.persisted
  end
end
