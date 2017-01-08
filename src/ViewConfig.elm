module ViewConfig exposing (..)


type alias ViewConfig =
    { borderSize : Int
    , cellSize : Int
    , svgSize : Int
    }


config : ViewConfig
config =
    { borderSize = 5
    , cellSize = 10
    , svgSize = 500
    }


scale : Float
scale =
    2


viewBoxSize : ViewConfig -> Float
viewBoxSize config =
    toFloat config.svgSize / scale


visibleCells : ViewConfig -> Int
visibleCells config =
    floor (((viewBoxSize config) - toFloat (config.borderSize * 2)) / toFloat config.cellSize)


farBorderPosition : ViewConfig -> Int
farBorderPosition config =
    (config.cellSize * visibleCells config) + config.borderSize
