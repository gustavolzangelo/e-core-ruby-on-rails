FactoryBot.define do
  factory :role do
    name { Faker::Job.title }
  end
end