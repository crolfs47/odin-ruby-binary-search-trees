# running this file will start the driver script requested in this project

require_relative 'node'
require_relative 'tree'

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
puts "Tree balanced? #{tree.balanced?}"
puts "Level order: #{tree.level_order}"
puts "Inorder: #{tree.inorder}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
5.times { tree.insert(rand(100..999)) }
puts "New tree balanced? #{tree.balanced?}"
tree.rebalance
puts "New tree balanced? #{tree.balanced?}"
puts "Level order: #{tree.level_order}"
puts "Inorder: #{tree.inorder}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
tree.pretty_print()
