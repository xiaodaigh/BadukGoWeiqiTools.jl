# functions for solving life and death problems


function solve_ld(board::LDBoard, playable_area = get_playable_area(board))
  # the playable_area should be a list of coordindate indicating possible positions of play

  for move in playable_area
    if can_move(board, move)
      solve_ld(board, playable_area)
    end
  end
end
