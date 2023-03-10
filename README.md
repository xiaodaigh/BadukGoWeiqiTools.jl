# BadukGoWeiqiTools.jl

A toolset to make getting Baduk/Go/Weiqi data easier.

Some functions

| Function | Usage |
| -------- | ----- |
| `load_namesdb(path="namesdb")` |  Creates a `Dict` that maps Kanji names to English and caches the result to `path`. If the cache exists, it will load from cache  |
| `headtohead(name1, name2)` | Returns the head to head record of players according to goratings.org  |
| `create_player_info_tbl()` | Returns a table with player name and nationality and other info |

## Katago

If you have Katago installed and accessible from `PATH`, then you can use KataGo to analyze a game

```julia
analyze_sgf(path_to_sgf_file; katago_model="katago_model.bin.gz", katago_config="some.cfg")
```