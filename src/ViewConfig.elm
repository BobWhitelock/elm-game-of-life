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


viewBoxSize : ViewConfig -> Float -> Float
viewBoxSize config zoomLevel =
    (toFloat config.svgSize) / zoomLevel


visibleCells : ViewConfig -> Float -> Int
visibleCells config zoomLevel =
    floor (((viewBoxSize config zoomLevel) - toFloat (config.borderSize * 2)) / toFloat config.cellSize)


farBorderPosition : ViewConfig -> Float -> Int
farBorderPosition config zoomLevel =
    (config.cellSize * visibleCells config zoomLevel) + config.borderSize
