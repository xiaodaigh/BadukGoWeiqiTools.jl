export headtohead

using DataFrames, Chain, DataFrameMacros
using Cascadia: nodeText
using TableScraper: scrape_tables
# using Infiltrator
using Tables

function headtohead(name1, name2; verbose=true)
    # get the front page
    front_page_url = "https://www.goratings.org/en/"
    front_page = scrape_tables(front_page_url, identity)[2] |> DataFrame

    player1_url = @chain front_page begin
        @transform :url = front_page_url*:Name[1].attributes["href"][7:end]
        @subset nodeText(:Name) == name1
        select(_, :url).url[1]
    end

    opp1 = @chain player1_url begin
        scrape_tables(_)[2]
    end

    # println("got here")
    # @infiltrate
    opp1 = DataFrame(opp1)
    # println("didn't got here")

    opp1a = @chain opp1 begin
        @subset :Opponent1 == name2
    end

    opp2 = @chain opp1a begin
        @groupby(:Result)
        @combine(:nrow = length(:Opponent1))
    end

    wins = 0
    losses = 0

    lv = opp2.Result .== "Loss"
    if any(lv)
        losses = opp2[lv, :nrow][1]
    end

    wv = opp2.Result .== "Win"
    if any(wv)
        wins = opp2[wv, :nrow][1]
    end

    if verbose
        println("## Head to head: $name1 vs $name2"); println("")
    end
    res = DataFrame(
        # Player1=[string(Player(name1))],
        Player1 = [name1],
        Record = ["$wins : $losses"],
        Player2 = [name2],
        # Player2=[string(Player(name2))],
    )

    res, select(@transform(opp1a, :Player1=name1), :Date, :Player1, :Opponent1=>:Player2, :Color, :Result)
end