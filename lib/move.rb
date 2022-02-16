class Move
  attr_accessor :board, :position, :fen

  def initialize(board, position)
    @board = board
    @fen = board.fen
    @position = position
  end

  def can_move
    true if can_move_from && can_move_to && can_piece_move
  end

  def can_move_from
    true if piece_color(position.piece_from) == fen.active
  end

  def piece_color(piece)
    /[[:upper:]]/.match(piece) ? 'w' : 'b'
  end

  def can_move_to
    if position.piece_to == ''
      true
    else
      piece_color(position.piece_to) != fen.active
    end
  end

  def can_piece_move
    piece = position.piece_from.to_s
    from = position.from.define_position
    to = position.to.define_position
    case piece.upcase
    when 'K'
      true if position.abs_delta_x <= 1 && position.abs_delta_y <= 1
    when 'N'
      if position.abs_delta_x == 1 && position.abs_delta_y == 2
        true
      elsif position.abs_delta_x == 2 && position.abs_delta_y == 1
        true
      else
        false
      end
    when 'Q'
      can_move_straight?
    when 'R'
      (position.sign_x == 0 || position.sign_y == 0) && can_move_straight?
    when 'B'
      (position.sign_x != 0 && position.sign_y != 0) && can_move_straight?
    when 'P'
      can_pawn_move
    end
  end

  def pawn?
    str = position.piece_from
    %w[P p].include?(str)
  end

  def king?
    str = position.piece_from
    %w[K k].include?(str)
  end

  def can_pawn_move
    if position.from.y > 6 || position.from.y < 1
      false
    else
      step_y = position.from.piece_color == 'w' ? -1 : 1
      can_pawn_go(step_y) || can_pawn_jump(step_y)  || can_pawn_eat(step_y)
    end
  end

  def can_pawn_go(step_y)
    true if position.to.piece == ' ' && (position.delta_x == 0) && (position.delta_y == step_y)
  end

  def can_pawn_jump(step_y)
    if position.to.piece == ' ' && (position.delta_x == 0) && (position.delta_y == 2 * step_y) && ((position.from.y == 1 || position.from.y == 6)) && (board.board[position.from.y + step_y][position.from.x].piece == ' ')
      true
    end
  end

  def can_pawn_eat(step_y)
    if board.board[position.to.y][position.to.x].piece != ' '
      if position.abs_delta_x == 1
        if position.delta_y == step_y
          true
        end
        end
    end
  end

  def can_move_straight?
    id = position.from
    at = board.board[id.y][id.x]
    loop do
      at = board.board[at.y + position.sign_y][at.x + position.sign_x]
      if at == position.to
        return true
      elsif if at.instance_of?(NilClass)
              return false
            elsif at.y + position.sign_y >= 8
              return false
            end
      end
      break if at.piece != ' '
    end
  end

  def to_algebraic_notation_string
    piece = position.piece_from
    piece_str = pawn? ? '' : piece.upcase
    "#{piece_str}#{position.from.define_position}#{position.to.piece == ' ' ? '' : 'x'}#{position.to.define_position}"
  end
end
