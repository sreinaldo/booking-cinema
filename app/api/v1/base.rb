require "grape-swagger"

module V1
  class Base < Grape::API
    mount V1::Movies
    mount V1::Bookings

    add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/swagger_doc",
        hide_format: true
    )
  end
end
