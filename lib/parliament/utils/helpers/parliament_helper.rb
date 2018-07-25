require 'parliament'
require 'parliament/ntriple'

module Parliament
  module Utils
    module Helpers
      module ParliamentHelper
        def self.parliament_request(request_id = nil, request_number = 1)
          headers = {}.tap do |headers|
            headers['Ocp-Apim-Subscription-Key'] = ENV['PARLIAMENT_AUTH_TOKEN']
            headers['Api-Version'] = ENV['PARLIAMENT_API_VERSION'] if ENV['PARLIAMENT_API_VERSION']
            headers['Request-Id'] = "#{request_id}#{request_number}" if request_id
          end

          Parliament::Request::UrlRequest.new(
            builder:    Parliament::Builder::NTripleResponseBuilder,
            headers:    headers,
            decorators: Parliament::Grom::Decorator
          )
        end

        def parliament_request(request_id = nil, request_number = 1)
          Parliament::Utils::Helpers::ParliamentHelper.parliament_request(request_id, request_number)
        end
      end
    end
  end
end
