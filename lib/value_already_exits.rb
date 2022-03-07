# frozen_string_literal: true

class ValueAlreadyExists < StandardError
  def initialize(msg = "Error: Value already exists in the tree")
    super
  end
end
