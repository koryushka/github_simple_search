# frozen_string_literal: true

class SearchResult
  attr_reader :data, :error

  def initialize(data: nil, error: nil)
    @data = data
    @error = error
  end
end
