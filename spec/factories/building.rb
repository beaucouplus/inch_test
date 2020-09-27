FactoryBot.define do
  sequence :ref do |n|
    n.to_s
  end
end

FactoryBot.define do
  factory :building do
    reference { generate(:ref) }
    current_profile_id { nil }
  end
end
