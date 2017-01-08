module Coordinates exposing (Coordinates, cellAtCoordinates)

import Cell exposing (Cell)
import ViewConfig exposing (ViewConfig, visibleCells)


type alias Coordinates =
    ( Int, Int )


cellAtCoordinates : ViewConfig -> Float -> Coordinates -> Maybe Cell
cellAtCoordinates config zoomLevel ( x, y ) =
    let
        cellX =
            x // config.cellSize

        cellY =
            y // config.cellSize

        gameSize =
            config.cellSize * visibleCells config zoomLevel

        outOfBounds =
            \( x, y ) ->
                x <= 0 || y <= 0 || x >= gameSize || y >= gameSize
    in
        if outOfBounds ( x, y ) then
            Nothing
        else
            Just ( cellX, cellY )
