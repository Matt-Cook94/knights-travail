# Knights Travails

require 'set'

# Square (Node) class
class Knight
  attr_accessor :src, :dst, :current_position, :valid_moves

  MOVES = [[2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2]].freeze

  def initialize(src, dst)
    @src = src
    @dst = dst
    @current_position = src
    @valid_moves = MOVES
  end

  def possible_moves(current_position)
    valid_moves = []

    MOVES.each do |move|
      row_inbounds = 0 <= (current_position[0] + move[0]) && (current_position[0] + move[0]) < 7
      col_inbounds = 0 <= (current_position[1] + move[1]) && (current_position[1] + move[1]) < 7
      if row_inbounds && col_inbounds
        a = current_position.map.with_index { |num, i| num + move[i] }
        valid_moves.push(a)
      end
    end
    valid_moves
  end
end

# Chess Board class
class ChessBoard
  attr_accessor :board, :knight

  def initialize
    @board = {}
    @knight = nil
    @moves = []
  end

  # Code to update adjacency list for board
  def update_board(knight, cur_pos)
    valid_edge = knight.possible_moves(cur_pos)

    valid_edge.each do |edge|
      a = cur_pos
      b = edge
      board[a] = [] unless board.include?(a)
      board[b] = [] unless board.include?(b)
      board[a].push(b) unless board[a].include?(b)
      board[b].push(a) unless board[b].include?(a)
    end

  end

  #Breadth First Traversal of chess board
  def knight_moves(src, dst)
    knight = Knight.new(src, dst)
    visited = Set.new([src])
    predecessor_array = [[src, nil]]
    queue = [[src, 0]]

    while queue.length > 0
      square, distance = queue.shift
      knight.current_position = square

      return shortest(distance, predecessor_array, dst) if square == dst
      
      update_board(knight, knight.current_position)

      board[square].each do |moveable_square|
        unless visited.include?(moveable_square)
          predecessor_array.push([moveable_square, square])
          visited.add(moveable_square)
          queue.push([moveable_square, distance + 1])
        end
      end

    end
    -1
  end

  def shortest(distance, array, dst)
    shortest = []
    predecessor = dst

    until predecessor.nil?
      array.each_index do |index|
        if array[index][0] == predecessor
          predecessor = array[index][1]
          shortest.push(array[index][0])
        end
      end
    end
    display_moves(distance, shortest.reverse)
  end

  def display_moves(distance, array)
    puts "You made it in #{distance} moves! Here's your path:"
    array.each do |square|
      p square
    end
  end

end


new_game = ChessBoard.new

p new_game.knight_moves([0,0], [2,4])
