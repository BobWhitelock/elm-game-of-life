module ViewConfig exposing (..)


type alias ViewConfig =
    { borderSize : Int
    , cellSize : Int
    , visibleCells : Int
    }


config : ViewConfig
config =
    { borderSize = 5
    , cellSize = 10
    , visibleCells = 24
    }


farBorderPosition : ViewConfig -> Int
farBorderPosition config =
    (config.cellSize * config.visibleCells) + config.borderSize
