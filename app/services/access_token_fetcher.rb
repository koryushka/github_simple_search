# frozen_string_literal: true

class AccessTokenFetcher
  CLIENT_ID = 'CLIENT_ID'
  CLIENT_SECRET = 'CLIENT_SECRET'
  URL = 'https://github.com/login/oauth/access_token'
  HEADERS = { 'Accept' => 'application/json' }.freeze

  def initialize(code)
    @code = code
  end

  def call
    token = response.parsed_response['access_token']
    return token if token

    Rails.logger.error(response.parsed_response)
    false
  end

  private

  attr_reader :code

  def body
    {
      client_id: client_id,
      client_secret: client_secret,
      code: code
    }
  end

  def response
    @response ||= HTTParty.post(URL, body: body, headers: HEADERS)
  end

  def client_id
    fetch_from_env(CLIENT_ID)
  end

  def client_secret
    fetch_from_env(CLIENT_SECRET)
  end

  def fetch_from_env(name)
    ApplicationController.helpers.fetch_from_env(name)
  end
end
