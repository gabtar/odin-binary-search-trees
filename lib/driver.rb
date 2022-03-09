# frozen_string_literal: true

require_relative 'tree'

puts '------------------------------------------------------------------------'
puts 'Creating a random binary tree'
# Create a binary search tree from an array of random numbers
my_tree = Tree.new(Array.new(15) { rand(1..100) })

my_tree.pretty_print

puts "The three is balanced?: #{my_tree.balanced?}"
puts "BFS Level Order: #{my_tree.level_order}"
puts "DFS Preorder: #{my_tree.preorder}"
puts "DFS Inorder: #{my_tree.inorder}"
puts "DFS Postorder: #{my_tree.postorder}"

# Unbalance the tree
puts '------------------------------------------------------------------------'
Array.new(15) { rand(101..200) }.each do |number|
  my_tree.insert(number)
rescue # Avoid ValueAlreadyExists exception
end
puts 'Adding some random numbers to unbalance the tree...'
my_tree.pretty_print
puts "The three is balanced?: #{my_tree.balanced?}"
puts '------------------------------------------------------------------------'
puts 'Rebalancing the tree...'
my_tree.rebalance!
my_tree.pretty_print
puts "The three is balanced?: #{my_tree.balanced?}"
puts "BFS Level Order: #{my_tree.level_order}"
puts "DFS Preorder: #{my_tree.preorder}"
puts "DFS Inorder: #{my_tree.inorder}"
puts "DFS Postorder: #{my_tree.postorder}"
