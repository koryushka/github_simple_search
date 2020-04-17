# frozen_string_literal: true

class GithubRepoSearcher
  PATH = '/search/repositories'

  def initialize(search_params, github_token)
    @search_params = search_params
    @github_token = github_token
  end

  def call
    if client.successful?
      SearchResult.new(data: client.results)
    else
      SearchResult.new(error: client.error)
    end
  end

  private

  attr_reader :search_params, :github_token

  def client
    @client ||= GithubClient.new(search_path, github_token)
  end

  def search_path
    "#{PATH}?q=#{search_params}"
  end
end
