FactoryBot.define do
  factory :building_profile do
    building
    address { Faker::Address.street_name }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    country { Faker::Address.country }
    manager_name { Faker::Name.name }

    trait :with_existing_building do
      building { Building.last }
    end
  end
end
