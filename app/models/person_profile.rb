class PersonProfile < ApplicationRecord
  include Scopes

  NO_OVERWRITE = %i[email home_phone_number mobile_phone_number address].freeze

  belongs_to :person
  has_one :current_person, class_name: 'Person', foreign_key: :current_profile_id
end
