require 'pry-byebug'
# A class that has functionality for building and interacting with a binary tree.
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array, 0, array.length - 1) 
  end

  def build_tree(array, start, final)
    return nil if start > final

    mid = (start + final) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, final)
    root
  end

  def insert(value, root)
    return Node.new(value) if root == nil

    if root.data == value
      return root
    elsif root.data < value
      root.right = insert(value, root.right)
    else
      root.left = insert(value, root.left)
    end
    root
  end

  def delete(value, root)
    if !root.nil?
      if value == @root.data
        return @root = nil
      end 
      if value == root.left.data
        root.left = nil
      elsif value == root.right.data
        root.right = nil
      elsif value > root.data
        delete(value, root.right)
      else
        delete(value, root.left)
      end
    end
  end

  def find(value, root)
    if value == root.data
      return root
    elsif value > root.data && !root.right.nil?
      find(value, root.right)
    elsif value < root.data && !root.left.nil?
      find(value, root.left)
    end
  end

  def level_order(queue, level_order, tree_array)
    if block_given?
      while queue.length > 0
        root = queue[0]
        yield root
        level_order.append(queue[0])
        queue.shift
        if !root.left.nil?
          queue.append(root.left)
        end
        if !root.right.nil?
          queue.append(root.right)
        end
      end
    else
      print tree_array
    end
  end

  def inorder(root, array)
    return if root == nil

    inorder(root.left, array) {}
    array.append(root.data)
    inorder(root.right, array) {}
    yield array
  end

  def preorder(root, array)
    return if root == nil

    array.append(root.data)
    preorder(root.left, array) {}
    preorder(root.right, array) {}
    yield array
  end

  def postorder(root, array)
    return if root == nil

    postorder(root.left, array) {}
    postorder(root.right, array) {}
    array.append(root.data)
    yield array
  end 

  def depth(target, array, test_array)
    depth = 0
    if target == array[0]
      return depth
    end
    while array.length >= 1
      array.each do |element|
        test_array.append(element.left) unless element.left.nil?
        test_array.append(element.right) unless element.right.nil?
      end
      array = []
      array = test_array
      test_array = []
      depth += 1
      array.each do |element|
      if element == target
        return depth
      end
      end
    end
  end

  def height(root)
    height = 0
    array = [root]
    test_array = []
    while array.length >= 1
      array.each do |element|
        test_array.append(element.left) unless element.left.nil?
        test_array.append(element.right) unless element.right.nil?
      end
      array = []
      array = test_array
      test_array = []
      return height if array.empty?

      height += 1
    end
  end

  def balanced?(root)
    left_height = height(root.left)
    right_height = height(root.right)

    if left_height - right_height < -1 || left_height - right_height > 1
      false
    else
      true
    end
  end

  def rebalance(root)
    array = []
    level_order([root],[],[]) {|element| array.append(element.data)}
    print "#{array} \n\n\n" 
    @root = build_tree(array, 0, array.length - 1) 
    build_tree(array, 0, array.length - 1)
  end



  # Thanks to the Odin Project student that wrote this pretty print method for the binary tree!
  def pretty_print(node = @root, prefix = '', is_left = true)
    if root != nil
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
  end
end


# A class describing the individual nodes of the tree and the relationship to the nodes
# left and right children (if they exist)
class Node
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end


tree_array = Array.new(15) {rand(1..100)}
tree = Tree.new(tree_array)
tree.build_tree(tree_array.uniq.sort, 0, tree_array.length - 1)
puts tree.balanced?(tree.root)
tree.inorder(tree.root, []) { |array| print array}
tree.preorder(tree.root, []) { |array| print array}
tree.postorder(tree.root, []) { |array| print array}
tree.insert(150, tree.root)
tree.insert(200, tree.root)
tree.insert(250, tree.root)
puts tree.balanced?(tree.root)
tree.rebalance(tree.root)
puts tree.balanced?(tree.root)
tree.inorder(tree.root, []) { |array| print array}
tree.preorder(tree.root, []) { |array| print array}
tree.postorder(tree.root, []) { |array| print array}
