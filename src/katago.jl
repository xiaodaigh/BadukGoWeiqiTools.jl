
export analyze_sgf

sgf_moves_to_katago_json(sgf::SGF; kwargs...) = sgf_moves_to_katago_json(sgf.moves; kwargs...)

function sgf_moves_to_katago_json(moves; id = randstring(8), rules="korean")
    json = copy(JSON3.read("""
    {"rules":"$rules", "boardXSize":19, "boardYSize":19}
    """
    ))

    json[:id] = id

    move_arr1 = map(moves) do move
        move_str = move.move_str
        col = uppercase(move_str[3])
        if Int(col) >= 73 # the letter I is skipped since it can look like a 1
            col = Char(Int(col) + 1)
        end
        ["$(move_str[1])", "$(col)$(Int(move_str[4])-96)"]
    end

    # "[" * join(move_arr1, ",") * "]"
    json[:moves] = move_arr1
    json[:analyzeTurns] = collect(0:length(moves)-1)

    json
end

function analyze_sgf(path; kwargs...)
    analyze_sgf(SGF(path); kwargs...)
end

function analyze_sgf(sgf::SGF; katago_model_path, katago_config_path, rules="korean")
    tf = tempname()
    tf_res = tempname()

    json = sgf_moves_to_katago_json(sgf; rules)

    JSON3.write(tf, json)

    cmd = `katago analysis -model $katago_model_path -config $katago_config_path`

    run(pipeline(cmd, stdin = tf, stdout = tf_res))

    json_res = String(tf_res |> read)

    # each move is a json
    filter(x -> x != "", split(json_res, "\n")) .|> JSON3.read
end
