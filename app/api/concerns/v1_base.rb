module V1Base
  extend ActiveSupport::Concern

  included do
    format :json
    prefix :api
    default_format :json

    version 'v1', using: :header, vendor: API_VENDOR

    # rescue_from Sequel::ForeignKeyConstraintViolation do |e|
    #   puts(e)
    #   render_error(RESPONSE_CODE[:bad_request], e)
    # end

    helpers do
      def render_error(code, message)
        error!({meta: {code: code, message: message}}, code)
      end

      def render_success(json, extra_meta = {})
        {data: json, meta: {code: RESPONSE_CODE[:success], message: "success"}.merge(extra_meta)}
      end
    end
  end
end
