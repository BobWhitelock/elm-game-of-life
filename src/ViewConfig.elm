module ViewConfig exposing (..)

import ZoomLevel exposing (ZoomLevel)


type alias ViewConfig =
    { borderSize : Int
    , cellSize : Int
    , svgSize : Int
    , zoomLevel : ZoomLevel
    }


defaultConfig : ViewConfig
defaultConfig =
    { borderSize = 5
    , cellSize = 10
    , svgSize = 500
    , zoomLevel = ZoomLevel.initial
    }


viewBoxSize : ViewConfig -> Float
viewBoxSize config =
    (toFloat config.svgSize) / ZoomLevel.scale config.zoomLevel


visibleCells : ViewConfig -> Int
visibleCells config =
    floor (((viewBoxSize config) - toFloat (config.borderSize * 2)) / toFloat config.cellSize)


farBorderPosition : ViewConfig -> Int
farBorderPosition config =
    (config.cellSize * visibleCells config) + config.borderSize


minimumZoomLevel : Float
minimumZoomLevel =
    0.125


maximumZoomLevel : Float
maximumZoomLevel =
    2
