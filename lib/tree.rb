require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
    pretty_print(@root)
  end

  def build_tree(array)
    return if array.empty?

    sorted_array = array.sort.uniq
    length = sorted_array.length
    return Node.new(sorted_array[0]) if length <= 1

    mid = length / 2
    root = Node.new(sorted_array[mid])
    root.left_child = build_tree(sorted_array[0..mid - 1])
    root.right_child = build_tree(sorted_array[mid + 1..length])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
array2 = [5, 7, 1, 3, 2, 6, 4]
Tree.new(array)