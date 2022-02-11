export SGF

import JSON3

using Random: randstring

struct Move
    move_str::String
    function Move(move_str)
        move_str1 = String(move_str)
        @assert length(move_str1) == 5
        new(move_str1)
    end
end

struct SGF
    attributes::String
    moves::Vector{Move}


    function SGF(path)
        content = reduce(*, readlines(path))
        # get rid of the ( and )
        attributes, moves... = split(content[3:end-1], ";")

        new(attributes, Move.(moves))
    end
end
