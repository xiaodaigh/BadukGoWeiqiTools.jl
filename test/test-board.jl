using DataFrames, DataFrameMacros, Chain, JDF
using BadukGoWeiqiTools: scrape_kifu_depot_table, load_namesdb

NAMESDB = load_namesdb("namesdb")

# load all past games to figure out head to heads
# allgames = @chain JDF.load("c:/git/baduk-go-weiqi-ratings/kifu-depot-games-for-ranking.jdf/") begin
#     DataFrame
#     @transform :black = get(NAMESDB, :black, "")
#     @transform :white = get(NAMESDB, :white, "")
#     # @subset :black != ""
#     # @subset :white != ""
# end

allgames_w_sgf = @chain JDF.load("c:/weiqi/web-scraping/kifu-depot-games-with-sgf.jdf/") begin
    DataFrame
    @transform :black = get(NAMESDB, :black, "")
    @transform :white = get(NAMESDB, :white, "")
    # @subset :black != ""
    # @subset :white != ""
end

using BadukGoWeiqiTools
using BadukGoWeiqiTools: Board, decode_move, SGF, get_moves, make_move!

sgf = SGF(allgames_w_sgf[1, :sgf])
bb = Board()
make_move!.(Ref(bb), sgf.moves)

