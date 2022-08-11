# frozen_string_literal: true

require_relative "./http_client"

module AtlassianJwtAuthentication
  module Oauth2
    EXPIRE_IN_SECONDS = 60
    AUTHORIZATION_SERVER_URL = "https://auth.atlassian.io"
    JWT_CLAIM_PREFIX = "urn:atlassian:connect"
    GRANT_TYPE = "urn:ietf:params:oauth:grant-type:jwt-bearer"
    SCOPE_SEPARATOR = " "

    def self.get_access_token(current_jwt_token, account_id, scopes = nil)
      response = HttpClient.new.post(AUTHORIZATION_SERVER_URL + "/oauth2/token") do |request|
        request.headers["Content-Type"] = Faraday::Request::UrlEncoded.mime_type
        request.body = {
          grant_type: GRANT_TYPE,
          assertion: prepare_jwt_token(current_jwt_token, account_id),
          scopes: scopes&.join(SCOPE_SEPARATOR)&.upcase,
        }.compact
      end

      raise "Request failed with #{response.status}" unless response.success?

      JSON.parse(response.body)
    end

    def self.prepare_jwt_token(current_jwt_token, account_id)
      unless current_jwt_token
        raise "Missing Authentication context"
      end

      unless account_id
        raise "Missing User key"
      end

      # Expiry for the JWT token is 3 minutes from now
      issued_at = Time.now.utc.to_i
      expires_at = issued_at + EXPIRE_IN_SECONDS

      JWT.encode({
        iss: JWT_CLAIM_PREFIX + ":clientid:" + current_jwt_token.oauth_client_id,
        sub: JWT_CLAIM_PREFIX + ":useraccountid:" + account_id,
        tnt: current_jwt_token.base_url,
        aud: AUTHORIZATION_SERVER_URL,
        iat: issued_at,
        exp: expires_at,
      }, current_jwt_token.shared_secret)
    end
  end
end
