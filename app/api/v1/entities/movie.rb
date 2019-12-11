module V1
  module Entities
    class Movie < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "Movie's unique id"}
      expose :name, documentation: { type: "String", desc: "Movie name"}
      expose :description, documentation: { type: "String", desc: "Movie description"}
      expose :image_url, documentation: { type: "String", desc: "Image URL"}
      expose :show_days, documentation: { type: "Array[String]", desc: "Day of the week that is shown"}
    end
  end
end
