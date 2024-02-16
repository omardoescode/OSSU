# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces + [rotations([[0, 0], [0, 1], [1, 0], [1, 1], [1, 2]]),
                                [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],
                                 [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]],
                                rotations([[0, 0], [0, -1], [1, 0]])]

  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.next_cheat_piece(board)
    MyPiece.new(rotations([[0, 0], [0, 0], [0, 0], [0, 0]]), board)
  end
end

class MyBoard < Board
  def initialize(game)
    super
    @current_block = MyPiece.next_piece(self)
    @special_case = false
  end

  # gets the next piece
  def next_piece
    if @special_case
      @current_block = MyPiece.next_cheat_piece(self)
      @special_case = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  def rotate_piece
    rotate_clockwise
    rotate_clockwise
  end

  def cheat
    if @score >= 100 and not @special_case
      @score -= 100
      @special_case = true
    end
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each { |index|
      current = locations[index]
      @grid[current[1] + displacement[1]][current[0] + displacement[0]] = @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc { @board.rotate_piece })
    @root.bind('c', proc { @board.cheat })
  end

end


