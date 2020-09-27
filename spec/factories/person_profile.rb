FactoryBot.define do
  factory :person_profile do
    person
    address { Faker::Address.street_name }
    home_phone_number { Faker::PhoneNumber.phone_number }
    mobile_phone_number { Faker::PhoneNumber.cell_phone }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }

    trait :with_existing_person do
      person { Person.last }
    end
  end
end
