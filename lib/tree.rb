# frozen_string_literal: true

# require 'pry-byebug'
require_relative './tree_node'
require_relative './value_already_exits'

##
# A Binary Search Tree
class Tree
  attr_accessor :root

  ##
  # Creates a new Tree object from +array+ or
  # returns a default empty tree structure
  def initialize(array = [])
    @root = build_tree(array)
  end

  ##
  # Builds a balanced binary tree from +array+
  def build_tree(array)
    array.sort!.uniq!
    return nil if array.empty?

    mid = (array.length / 2).floor
    root = TreeNode.new(array[mid])

    root.left = build_tree(array.slice(0, mid))
    root.right = build_tree(array.slice(mid + 1, array.length))

    root
  end

  ##
  # Inserts a new node with +value+ in the current tree
  # Raises a ValueAlreadyExists if there is already a node
  # that contains +value+
  def insert(value, current_node = root)
    raise ValueAlreadyExists if find(value)

    return TreeNode.new(value) if current_node.nil?

    if value > current_node.value
      current_node.right = insert(value, current_node.right)
    else
      current_node.left = insert(value, current_node.left)
    end
    current_node
  end

  ##
  # Deletes +value+ in the current tree
  # If node is not a leaf node, rearanges the tree
  # deleting only +value+
  def delete(value, current_node = root)
    return nil if current_node.nil?

    if value > current_node.value
      current_node.right = delete(value, current_node.right)
    elsif value < current_node.value
      current_node.left = delete(value, current_node.left)
    elsif current_node.right.nil?
      current_node = current_node.left
    elsif current_node.left.nil?
      current_node = current_node.right
    else
      current_node.value = min_value_of_subtree(current_node.right).value
      current_node.right = delete(current_node.value, current_node.right)
    end
    current_node
  end

  ##
  # Finds +value+ in the current tree
  def find(value, current_node = root)
    return nil if current_node.nil?

    if value == current_node.value
      current_node
    elsif value > current_node.value
      find(value, current_node.right)
    elsif value < current_node.value
      find(value, current_node.left)
    end
  end

  ##
  # Returns an array with in breadth-first level order of the tree
  # If a block if passed, it yields each node to the provided block
  def level_order(current_node = root)
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

  ##
  # Returns an array with depth-first preorder of the tree
  # If a block if passed, it yields each node to the provided block
  def preorder(current_node = root, preorder = [], &block)
    return nil if current_node.nil?

    block ? yield(current_node) : preorder << current_node.value
    preorder(current_node.left, preorder, &block)
    preorder(current_node.right, preorder, &block)

    preorder
  end

  ##
  # Returns an array with depth-first inorder of the tree
  # If a block if passed, it yields each node to the provided block
  def inorder(current_node = root, inorder = [], &block)
    return nil if current_node.nil?

    inorder(current_node.left, inorder, &block)
    block ? yield(current_node) : inorder << current_node.value
    inorder(current_node.right, inorder, &block)

    inorder
  end

  ##
  # Returns an array with depth-first postorder of the tree
  # If a block if passed, it yields each node to the provided block
  def postorder(current_node = root, postorder = [], &block)
    return nil if current_node.nil?

    postorder(current_node.left, postorder, &block)
    postorder(current_node.right, postorder, &block)
    block ? yield(current_node) : postorder << current_node.value

    postorder
  end

  ##
  # Returns the height of the given +node+
  def height(node)
    return 0 if node.nil?

    right_height = height(node.right)
    left_height = height(node.left)

    [right_height, left_height].max + 1
  end

  ##
  # Returns the depth of the given +node+ with respect to root node
  def depth(node, current_node = root)
    current_depth = 0

    # Check if value is higher or lower than current node value
    # break when node found
    until current_node == node
      if node > current_node
        current_node = current_node.right
      elsif node < current_node
        current_node = current_node.left
      end
      current_depth += 1
    end
    current_depth
  end

  ##
  # Returns true if the current tree is balanced
  # otherwise returns false
  def balanced?
    (height(root.left) - height(root.right)).between?(-1, 1)
  end

  ##
  # Rebalances current tree
  def rebalance!
    current_tree = level_order
    build_tree(current_tree)
  end

  ##
  # Prints the tree in terminal
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  ##
  # Returs the minimum value of the subtree +node+
  def min_value_of_subtree(node)
    current_node = node
    current_node = current_node.left until current_node.left.nil?
    current_node
  end
end

# Test
# tree = Tree.new([1, 2, 3])
# tree = Tree.new([1, 3, 6, 7, 8, 10, 14])
# p tree.find(8)
# tree.insert(6)
# tree.insert(4)
# tree.insert(5)
# tree.pretty_print
# p tree.level_order
# p tree.balanced?
# tree.rebalance!
# tree.pretty_print
# p tree.postorder
# tree.delete(1)
# puts tree.pretty_print
# puts tree.pretty_print
# tree.insert(7)
