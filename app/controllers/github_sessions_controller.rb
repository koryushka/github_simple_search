# frozen_string_literal: true

class GithubSessionsController < ApplicationController
  before_action :render_error, only: :callback, unless: -> { code }

  def callback
    github_token = access_token_fetcher.call
    if github_token
      session[:github_token] = github_token

      redirect_to(controller: 'repo_search', action: 'search')
    else
      render_error
    end
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

  def render_error
    render plain: 'Something went wrong'
  end
end
