class Badge
  include MongoMapper::Document

  key :name, String
  key :level, String
  key :image, String
  key :description, String
  timestamps!
end