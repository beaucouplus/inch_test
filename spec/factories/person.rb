FactoryBot.define do
  sequence :person_ref do |n|
    n.to_s
  end
end

FactoryBot.define do
  factory :person do
    reference { generate(:person_ref) }
    current_profile_id { nil }
  end
end
