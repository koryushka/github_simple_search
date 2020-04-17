# frozen_string_literal: true

class GithubSessionsController < ApplicationController
  def callback
    session[:github_token] = access_token_fetcher.call if code

    redirect_to(controller: 'repo_search', action: 'search')
  end

  def logout
    session.delete(:github_token)

    redirect_to(controller: 'repo_search', action: 'search')
  end

  private

  def access_token_fetcher
    @access_token_fetcher ||= AccessTokenFetcher.new(code)
  end

  def code
    @code ||= params[:code]
  end
end
