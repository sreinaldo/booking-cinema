module Requests
  module JsonHelpers
    def json_response
      @json ||= JSON.parse(response.body, symbolize_names: true)
      @json
    end
  end

  module HeadersHelpers
    def request_headers
      @headers ||= {}
    end


    def api_response_format
      request_headers['Content-Type'] = 'application/json'
    end

    def include_accept_headers
      api_response_format
    end
  end
end








