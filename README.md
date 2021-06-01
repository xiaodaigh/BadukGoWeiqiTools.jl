# BadukGoWeiqiTools.jl

A toolset to make getting Baduk/Go/Weiqi data easier.

There are two key functions

| Function | Usage |
| -------- | ----- |
| `load_namesdb(path="namesdb")` |  Creates a `Dict` that maps Kanji names to English and caches the result to `path`. If the cache exists, it will load from cache  |
| `scrape_kifu_depot_table(; player, event, page)` | Which scrapes games from kifudept.net  |
