FactoryGirl.define do
  to_create {|instance| instance.save }

  factory :movie do
    name {"#{Faker::Movie.quote}#{rand(9999999999999)}"}
    description { Faker::Lorem.sentence }
    show_days {[0,1,2,3]}
    image_url { Faker::Internet.url }
  end
end
