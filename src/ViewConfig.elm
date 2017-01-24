module ViewConfig exposing (..)

import ZoomLevel exposing (ZoomLevel)
import Cell exposing (Cell)


type alias ViewConfig =
    { borderSize : Int
    , cellSize : Int
    , svgSize : Int
    , zoomLevel : ZoomLevel
    , topLeft : Cell
    , panShift : Float
    }


defaultConfig : ViewConfig
defaultConfig =
    { borderSize = 5
    , cellSize = 10
    , svgSize = 500
    , zoomLevel = ZoomLevel.initial
    , topLeft = ( -20, -20 )
    , panShift = 0.1
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
