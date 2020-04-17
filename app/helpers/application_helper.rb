# frozen_string_literal: true

module ApplicationHelper
  def logged_in?
    session[:github_token].present?
  end

  def fetch_from_env(name)
    ENV.fetch(name) do
      raise(ArgumentError, "Set #{name} in the environment")
    end
  end
end
