FactoryGirl.define do
  factory :booking do
    sequence(:first_name){|n|"#{n}#{Faker::Name.first_name}"}
    sequence(:last_name){|n|"#{n}#{Faker::Name.last_name}"}
    sequence(:email){|n|"#{n}#{Faker::Internet.email}"}
    date {Time.now.strftime("%Y-%m-%d")}
    association :movie
  end
end
