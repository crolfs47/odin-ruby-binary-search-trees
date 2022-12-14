require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
    @array = []
    pretty_print(root = @root)
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
    array = []
    queue.push(root)
    while queue.length >= 1
      visit_node = queue.shift
      block.call(visit_node) if block_given?

      array.push(visit_node.data)
      queue.push(visit_node.left_child) unless visit_node.left_child.nil?
      queue.push(visit_node.right_child) unless visit_node.right_child.nil?
    end
    array unless block_given?
  end

  # accepts a block and traverses the tree in depth-first order
  # and yields each node to the provided block
  def inorder(node = root, array = [], &block)
    return node if node.nil?

    inorder(node.left_child, array, &block)
    array.push(node.data)
    block.call(node) if block_given?
    inorder(node.right_child, array, &block)
    array unless block_given?
  end

  def preorder(node = root, array = [], &block)
    return node if node.nil?

    block.call(node) if block_given?
    preorder(node.left_child, array, &block)
    preorder(node.right_child, array, &block)
    array.push(node.data) unless block_given?
  end

  def postorder(node = root, array = [], &block)
    return node if node.nil?

    postorder(node.left_child, array, &block)
    postorder(node.right_child, array, &block)
    block.call(node) if block_given?
    array.push(node.data) unless block_given?
  end

  def height(node)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    [left_height, right_height].max + 1
  end

  def depth(node)
    return node if node.nil?

    current = root
    i = 0
    until current.data == node.data
      if node.data < current.data
        current = current.left_child
      elsif node.data > current.data
        current = current.right_child
      end
      i += 1
    end
    i
  end

  def balanced?
    diff = height(root.left_child) - height(root.right_child)
    return true if diff.between?(-1, 1)

    false
  end

  def rebalance(root = @root)
    array = inorder(root)
    @root = build_tree(array)
  end
end




