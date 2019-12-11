module V1
  module Entities
    class Booking < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "Booking's unique id"}
      expose :first_name, documentation: { type: "String", desc: "Customer First Name"}
      expose :last_name, documentation: { type: "String", desc: "Customer Last Name"}
      expose :email, documentation: { type: "String", desc: "Customer Email"}
      expose :date, documentation: { type: "Date", desc: "Booking's Date"}
      expose :movie, using: V1::Entities::Movie
    end
  end
end
