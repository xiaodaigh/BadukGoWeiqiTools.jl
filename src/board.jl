export print, display

# simulate boards

@enum Stone b w e # black, white, empty

import Base: print, display
struct Board
    board::Array{Stone,2}
    Board() = new(fill(e, 19, 19))
end


function Base.print(board::Board)
    for row in 1:19
        for col in 1:19
            print(board.board[row, col])
        end
        println()
    end
end

function Base.display(board::Board)
    for row in 1:19
        for col in 1:19
            print(board.board[row, col])
        end
        println()
    end
end


function get_moves(sgf::SGF)
    get_moves(sgf.moves)
end


function get_moves(sgf1::AbstractString)
    moves = split(sgf1, ";")[3:end]
    try
        @assert moves[1][1] == 'B'
        return moves
    catch
        return []
    end
end

# fill the board
function decode_move(move_str::String)
    color = move_str[1]
    @assert color in ('B', 'W')
    col = Int(move_str[3]) - 96
    row = Int(move_str[4]) - 96

    ifelse(color == 'B', b, w), row, col
end

function decode_move(move::Move)
    decode_move(move.move_str)
end


# check if the stone at start_x, start_y is in a captured state
function check_capture!(board, start_x, start_y, color)
    if start_x < 1 || start_x > 19 || start_y < 1 || start_y > 19
        return false, Tuple{Int,Int}[]
    end

    if color == e
        return false, Tuple{Int,Int}[]
    end
    opp_col = ifelse(color == b, w, b)

    been_there = fill(false, 19, 19)

    connected_pieces = [(start_x, start_y)]
    captured_pieces = Tuple{Int,Int}[]

    while length(connected_pieces) > 0
        piece_xy = pop!(connected_pieces)
        piece_in_question = board[piece_xy[1], piece_xy[2]]
        been_there[piece_xy[1], piece_xy[2]] = true

        if piece_in_question == e
            # there's still a liberty
            return false, Tuple{Int,Int}[]
        elseif piece_in_question == opp_col
            continue # skip the rest
        end

        # colour must be the same as original colour if the code gets here
        push!(captured_pieces, (piece_xy[1], piece_xy[2]))

        if piece_xy[1] > 1
            if been_there[piece_xy[1]-1, piece_xy[2]] == false
                push!(connected_pieces, (piece_xy[1] - 1, piece_xy[2]))
            end
        end
        if piece_xy[1] < 19
            if been_there[piece_xy[1]+1, piece_xy[2]] == false
                push!(connected_pieces, (piece_xy[1] + 1, piece_xy[2]))
            end
        end
        if piece_xy[2] > 1
            if been_there[piece_xy[1], piece_xy[2]-1] == false
                push!(connected_pieces, (piece_xy[1], piece_xy[2] - 1))
            end
        end
        if piece_xy[2] < 19
            if been_there[piece_xy[1], piece_xy[2]+1] == false
                push!(connected_pieces, (piece_xy[1], piece_xy[2] + 1))
            end
        end
    end

    return true, captured_pieces
end

# check if making a move at row, col captures anything
function any_capture(board, row, col)
    move_col = board[row, col]
    capture_col = ifelse(move_col == b, w, b)
    tf1, cp1 = check_capture!(board, row + 1, col, capture_col)

    tf2, cp2 =
        check_capture!(board, row - 1, col, capture_col)

    tf3, cp3 =
        check_capture!(board, row, col + 1, capture_col)

    tf4, cp4 =
        check_capture!(board, row, col - 1, capture_col)

    reduce(vcat, [cp1, cp2, cp3, cp4])
end

function any_capture(board::Board, row, col)
    any_capture(board.board, row, col)
end


function make_move!(board::Board, row, col, stone::Stone)
    @assert stone in (b, w)
    board.board[row, col] = stone

    # if check if there's capture
    captures = unique(any_capture(board, row, col))

    for (row, col) in captures
        board.board[row, col] = e
    end

    return captures
end

function make_move!(board::Board, move::Move)
    stone, row, col = decode_move(move)
    make_move!(board, row, col, stone)
end


struct BoardSimulation
    initboard::Board
    playable_area::Array{Tuple{Int,Int},2}
    stones_to_capture::Array{Tuple{Int,Int},2}
end