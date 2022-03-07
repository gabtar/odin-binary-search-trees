# frozen_string_literal: true

require 'pry-byebug'

require_relative './tree_node'
require_relative './value_already_exits'

##
# A Binary Search Tree
class Tree
  attr_accessor :root

  def initialize(array = [])
    @root = build_tree(array)
  end

  def build_tree(array)
    array.sort!.uniq! # TODO, find another way?
    return nil if array.empty?

    mid = (array.length / 2).floor
    root = TreeNode.new(array[mid])

    root.left = build_tree(array.slice(0, mid))
    root.right = build_tree(array.slice(mid + 1, array.length))

    @root = root
  end

  def insert(value, current_node = @root)
    raise ValueAlreadyExists if find(value)

    return TreeNode.new(value) if current_node.nil?

    if value > current_node.value
      current_node.right = insert(value, current_node.right)
    else
      current_node.left = insert(value, current_node.left)
    end
    current_node
  end

  def delete(value, current_node = @root)
    return nil if current_node.nil?

    if value > current_node.value
      current_node.right = delete(value, current_node.right)
    elsif value < current_node.value
      current_node.left = delete(value, current_node.left)
    else
      if current_node.right.nil?
        current_node = current_node.left
      elsif current_node.left.nil?
        current_node = current_node.right
      else
        current_node.value = min_value_of_subtree(current_node.right).value
        current_node.right = delete(current_node.value, current_node.right)
      end
    end
    current_node
  end

  def find(value, current_node = @root)
    return nil if current_node.nil?

    if value == current_node.value
      current_node
    elsif value > current_node.value
      find(value, current_node.right)
    elsif value < current_node.value
      find(value, current_node.left)
    end
  end

  def level_order(current_node = @root)
    queue = []
    level_order = [] unless block_given?

    queue.push(current_node)

    until queue.empty?
      current_node = queue[0]

      queue.push(current_node.right) unless current_node.right.nil?
      queue.push(current_node.left) unless current_node.left.nil?

      block_given? ? yield(queue.shift) : level_order.push(queue.shift.value)
    end
    level_order
  end

  def preorder(current_node = @root, preorder = [], &block)
    return nil if current_node.nil?

    block ? yield(current_node) : preorder << current_node.value
    preorder(current_node.left, preorder, &block)
    preorder(current_node.right, preorder, &block)

    preorder
  end

  def inorder(current_node = @root, inorder = [], &block)
    return nil if current_node.nil?

    inorder(current_node.left, inorder, &block)
    block ? yield(current_node) : inorder << current_node.value
    inorder(current_node.right, inorder, &block)

    inorder
  end

  def postorder(current_node = @root, postorder = [], &block)
    return nil if current_node.nil?

    postorder(current_node.left, postorder, &block)
    postorder(current_node.right, postorder, &block)
    block ? yield(current_node) : postorder << current_node.value

    postorder
  end

  def height(node)
    return 0 if node.nil?

    right_height = height(node.right)
    left_height = height(node.left)

    [right_height, left_height].max + 1
  end

  def depth(node)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def min_value_of_subtree(node)
    current_node = node
    current_node = current_node.left until current_node.left.nil?
    current_node
  end
end

tree = Tree.new([1, 2, 3, 5])
# tree = Tree.new([1, 3, 6, 7, 8, 10, 14])

# p tree.find(2)
#
# p tree.find(8)
tree.insert(6)
tree.insert(4)
tree.pretty_print
p tree.level_order
# p tree.postorder
# tree.delete(1)
# puts tree.pretty_print
# puts tree.pretty_print
# tree.insert(7)
