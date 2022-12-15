require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
    @value_array = []
    pretty_print(@root)
    # insert(600)
    # insert(500)
    # pretty_print(@root)
    # p min_value_node(@root.right_child.right_child)
    # delete(67)
    # pretty_print(@root)
    # p find(7)
    # level_order { |node| p node.data }
    preorder(@root) { |node| p node.data }
    #   p node.data
    # end
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

  # accepts a value to insert
  def insert(value, node = root)
    if root.nil?
      Node.new(value)
    elsif value == node.data
      nil
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

  # accept a value to delete and returns the new root
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

  # accepts a value and returns the node with the given value
  def find(value, node = root)
    return node if node.nil?
    return node if value == node.data

    if value < node.data
      find(value, node.left_child)
    elsif value > node.data
      find(value, node.right_child)
    end
  end

  # accepts a block and traverses the tree in breadth-level order
  # and yields each node to the provided block, return an array
  # of values if no block is given
  def level_order(&block)
    return root if root.nil?

    queue = []
    value_array = []
    queue.push(root)
    while queue.length >= 1
      visit_node = queue.shift
      block.call(visit_node) if block_given?

      value_array.push(visit_node.data) 
      queue.push(visit_node.left_child) unless visit_node.left_child.nil?
      queue.push(visit_node.right_child) unless visit_node.right_child.nil?
    end
    value_array unless block_given?
  end

  # accepts a block and traverses the tree in depth-first order
  # and yields each node to the provided block
  def inorder(node = root)
    return node unless node.nil?

    p node.data
    inorder
  end

  def preorder(node = root, value_array = [])
    # value_array = []
    return node if node.nil?

    # if block_given?
    #   yield(node)
    # else
    #   @value_array.push(node.data)
    # end
    yield(node)
    preorder(node.left_child)
    preorder(node.right_child)
    # @value_array
  end

  def postorder
  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
array2 = [5, 7, 1, 3, 2, 6, 4]
Tree.new(array)


