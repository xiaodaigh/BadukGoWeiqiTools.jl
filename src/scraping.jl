using Gumbo: parsehtml
using Cascadia: @sel_str, nodeText
using DataFrames, JDF
using HTTP: get
import HTTP
using TableScraper

export scrape_kifu_depot_table, download_goratings

function right(str, start)
    String(str[5:end])
end

function scrape_kifu_depot_table(; player="", event="", page::Int=1)
    url = "https://kifudepot.net/index.php?page=$page&move=&player=$player&event=$event"
    _scrape_kifu_depot_table(url)
end

function _scrape_kifu_depot_table(url)
    df = DataFrame(scrape_tables(url, identity)[1])
    rename!(df, ["comp", "black", "white", "result", "date"])

    # extract the link to sgf here
    df[!, :kifu_link] = [comp[1].attributes["href"] for comp in df.comp]

    for n in ["comp", "black", "white", "result", "date"]
        df[!, n] = nodeText.(df[!, n])
    end

    tmp = right.(df[!, "result"], 5)

    tmp1 = split.(tmp, "+")

    df[!,:result] .= tmp

    df[!,:who_win] = [String(elem[1]) for elem in tmp1]

    function not_void(elem)
        if length(elem) == 2
            return String(elem[2])
        elseif length(elem) == 1
            return ""
        else
            return "check"
        end
    end

    df[!,:win_by] = [not_void(elem) for elem in tmp1]

    df
end

function extract_sgf(link)
    game = HTTP.get("https://kifudepot.net/"*link)
    eachmatch(sel"#sgf", parsehtml(String(game.body)).root)[1] |> nodeText
end

function extract_komi(sgf::String)
    # from https://stackoverflow.com/questions/66539167/how-to-capture-just-the-next-bracket-using-regular-expression-regex/66539200#66539200
    m = match(r"KM\[(?<komi>[^\]]*)", sgf)
    parse(Float64, m.captures[1])
end


function download_goratings(path)
    df = DataFrame(scrape_tables("https://www.goratings.org/en/")[2])
    rename!(df, [:rank, :player, :sex, :flag, :elo])
    select!(df, [:rank, :player, :elo])
    df[!, :elo] = parse.(Int, df[!, :elo])
    df[!, :rank] = parse.(Int, df[!, :rank])
    JDF.save(path, df)
end