# frozen_string_literal: true

class RepoSearchController < ApplicationController
  def search
    if search_params.present?
      @search_results = repo_searcher.call
    else
      render :search
    end
  end

  private

  def repo_searcher
    @repo_searcher ||= GithubRepoSearcher.new(search_params, session[:github_token])
  end

  def search_params
    @search_params ||= params[:q]
  end
end
