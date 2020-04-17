# frozen_string_literal: true

class GithubClient
  BASE_URL = 'https://api.github.com'

  attr_reader :results, :error

  def initialize(search_path, github_token)
    @search_path = search_path
    @github_token = github_token
  end

  def successful?
    if (200..300).cover?(response.code)
      @results = parsed_body
      true
    else
      @error = parsed_body[:message]
      false
    end
  end

  private

  attr_reader :search_path, :github_token

  def parsed_body
    @parsed_body ||= response.parsed_response
  end

  def params
    "#{BASE_URL}#{search_path}"
  end

  def response
    @response ||= HTTParty.get(params, headers: headers)
  end

  def headers
    {
      'Authorization' => "token #{github_token}",
      'User-Agent': 'Simple-Repo-Searcher '
    }
  end
end
