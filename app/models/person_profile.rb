class PersonProfile < ApplicationRecord
  belongs_to :person
  belongs_to :current_person, class_name: 'Person', foreign_key: :current_profile_id, optional: true
end
