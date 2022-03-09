# frozen_string_literal: true

##
# Represents a node of a Binary Search Tree
class TreeNode
  include Comparable

  attr_accessor :value, :left, :right

  def initialize(value = nil)
    @value = value
    @left = nil
    @right = nil
  end

  def <=>(other)
    @value <=> other.value
  end
end
