Fabricator(:badge, from: "Merit::Badge") do
  id           { SecureRandom.random_number(100_0000_000) }
  name         { Faker::Lorem.word }
  description  { Faker::Lorem.sentence }
end
