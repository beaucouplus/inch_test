class PersonProfile < ApplicationRecord
  include OnlyPersisted

  belongs_to :person
  has_one :current_person, class_name: 'Person', foreign_key: :current_profile_id
end
