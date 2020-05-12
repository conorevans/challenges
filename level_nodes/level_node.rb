module BinarySearch
  class Tree
    attr_reader :root, :nodes

    def initialize(value:)
      @root = Node.new(value: value)
      @nodes = { value.to_s => @root }
    end

    def populate(values:)
      values.each { |v| root.insert(v: v) }
    end

    def connect_level_nodes
      queue = Queue.new
      queue << root
      
      current_node = nil
      while !queue.empty? do
        queue.length.times do |i|
          previous_node = current_node
          current_node = queue.pop

          previous_node.level = current_node if i > 0

          queue.push(current_node.left) unless current_node.left.nil?
          queue.push(current_node.right) unless current_node.right.nil?
        end

        current_node.level = nil
      end      
    end

    def to_h
      queue = Queue.new
      queue << root

      while !queue.empty? do
        current_node = queue.pop
        nodes[current_node.value.to_s] = current_node

        queue.push(current_node.left) unless current_node.left.nil?
        queue.push(current_node.right) unless current_node.right.nil?
      end

      nodes
    end
  end

  private

  class Node
    attr_reader :value
    attr_accessor :left, :right, :level
  
    def initialize(value:)
      @value = value
    end

    def insert(v:)
      # accept only value of type int
      return unless defined?(v) && v.respond_to?(:to_i)
      # entries in BST are unique
      return if v == value
      return look_right(v: v) if v > value
      
      look_left(v: v)
    end

    def look_right(v:)
      return set_right(v) if right.nil? 
      
      right.insert(v: v)
    end

    def look_left(v:)
      return set_left(v) if left.nil?
      
      left.insert(v: v)
    end

    def set_right(v)
      self.right = Node.new(value: v)
    end

    def set_left(v)
      self.left = Node.new(value: v)
    end
  end
end
