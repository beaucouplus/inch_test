class Person < ApplicationRecord
  has_many :person_profiles
  has_one :current_profile, class_name: 'PersonProfile'
end
