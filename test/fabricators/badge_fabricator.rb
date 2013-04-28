Fabricator(:badge, from: "Merit::Badge") do
  id           { (rand * 100).to_i + 1 }
  name         { Faker::Lorem.word }
  description  { Faker::Lorem.sentence }
end
