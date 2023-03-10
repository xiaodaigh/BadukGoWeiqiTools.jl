export SGF, make_sgf, komi

import JSON3

using Random: randstring

import Base: print

struct Move
    move_str::String
    function Move(move_str)
        move_str1 = String(move_str)
        @assert length(move_str1) == 5
        new(move_str1)
    end
end

# Used to check if a file name is too long
function istoolong(filename)
    try
        stat(filename)
        false
    catch e
        if isa(e, Base.IOError)
            e.code == -36
        else
            rethrow()
        end
    end
end

# SGF stands for Smart Go (Game) Format
struct SGF
    attributes::String
    moves::Vector{Move}

    function SGF(string)
        if (!istoolong(string)) && isfile(string)
            content = reduce(*, readlines(string))
            # get rid of the ( and )
            attributes, moves... = split(content[3:end-1], ";")

            new(attributes, Move.(moves))
        else
            attributes, moves... = split(string[3:end-1], ";")
            new(attributes, Move.(moves))
        end
    end

    function SGF(a, m)
        new(a, m)
    end
end

function make_sgf(str::AbstractString)
    attributes, moves... = split(str[3:end-1], ";")
    SGF(attributes, Move.(moves))
end

function countmoves(sgf::SGF)
    length(sgf.moves)
end

function countmoves(sgf::String)
    countmoves(SGF(sgf))
end


function komi(sgf::SGF)::String
    try
        return match(r"KM\[(.*?)\].", sgf.attributes).captures[1]
    catch _
        return missing
    end
end

function komi(sgf::AbstractString)
    # tf = tempname()
    # write(tf, sgf)
    try
        sgf = SGF(sgf)
        return komi(sgf)
    catch _
        return missing
    end
end

