module Coordinates exposing (Coordinates, toCell, fromCell)

import Cell exposing (Cell)
import ViewConfig exposing (ViewConfig, visibleCells)


type alias Coordinates =
    ( Int, Int )


toCell : ViewConfig -> Coordinates -> Maybe Cell
toCell config ( x, y ) =
    let
        ( topLeftX, topLeftY ) =
            config.topLeft

        cellX =
            topLeftX + (x // config.cellSize)

        cellY =
            topLeftY + (y // config.cellSize)

        gameSize =
            config.cellSize * visibleCells config

        outOfBounds =
            \( x, y ) ->
                x <= 0 || y <= 0 || x >= gameSize || y >= gameSize
    in
        if outOfBounds ( x, y ) then
            Nothing
        else
            Just ( cellX, cellY )


fromCell : ViewConfig -> Cell -> Coordinates
fromCell config ( cellX, cellY ) =
    let
        ( topLeftX, topLeftY ) =
            config.topLeft
    in
        ( (cellX - topLeftX) * config.cellSize
        , (cellY - topLeftY) * config.cellSize
        )
