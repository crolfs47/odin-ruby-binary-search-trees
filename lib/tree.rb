require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
    pretty_print(@root)
    # insert(600)
    # insert(500)
    # pretty_print(@root)
    # p min_value_node(@root.right_child.right_child)
    delete(67)
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

  def insert(value, node = root)
    if root.nil?
      Node.new(value)
    elsif value == node.data
      return nil
    else
      if value < node.data
        node.left_child.nil? ? node.left_child = Node.new(value) : insert(value, node.left_child) 
      else
        node.right_child.nil? ? node.right_child = Node.new(value) : insert(value, node.right_child)
      end
    end
  end

  # return the node with the minimum value beneath node provided in method
  def min_value_node(node)
    current = node
    current = current.left_child until current.left_child.nil?
    current
  end

  # deletes the value provided and returns the new root
  def delete(value, node = root)
    return node if node.nil?

    if value < node.data
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      node.right_child = delete(value, node.right_child)
    else
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      min_node = min_value_node(node.right_child)
      node.data = min_node.data
      node.right_child = delete(min_node.data, node.right_child)
    end
    node
  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
array2 = [5, 7, 1, 3, 2, 6, 4]
Tree.new(array)

# 3 cases
# delete a leaf in the tree (end one)
    # structure won't change, node that previously pointed to that tree won't anymore
# delete a node with one child
    # replace it with its child, point node's parent to its child
# delete a node (Node A) with two children
    # find thing in tree that's next biggest (Node X), the smallest thing in it's right subtree
        # look in right subtree, node on very far left
        # recursively remove Node X
    # replace Node A with Node X

