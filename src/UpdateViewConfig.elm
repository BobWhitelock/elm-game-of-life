module UpdateViewConfig exposing (zoom, pan)

import ViewConfig exposing (ViewConfig)
import ZoomLevel exposing (ZoomLevel)
import Messages exposing (Direction(..))


zoom : (ZoomLevel -> ZoomLevel) -> ViewConfig -> ViewConfig
zoom changeZoom viewConfig =
    let
        newZoomLevel =
            changeZoom viewConfig.zoomLevel

        zoomedViewConfig =
            { viewConfig
                | zoomLevel = newZoomLevel
            }

        visibleCellsChange =
            ViewConfig.visibleCells zoomedViewConfig - ViewConfig.visibleCells viewConfig

        topLeftShift =
            -- After a zoom, the new `topLeft` Cell will be the old `topLeft`
            -- shifted by half the change in the number of visible Cells - this
            -- way the centre of the view will remain the same after any zoom.
            visibleCellsChange // 2

        ( x, y ) =
            viewConfig.topLeft

        newTopLeft =
            ( x - topLeftShift, y - topLeftShift )

        newViewConfig =
            { zoomedViewConfig
                | topLeft = newTopLeft
            }
    in
        newViewConfig


pan : Direction -> ViewConfig -> ViewConfig
pan direction viewConfig =
    let
        visibleCells =
            ViewConfig.visibleCells viewConfig

        topLeftShift =
            -- Whichever direction we pan in, we want to shift `visibleCells` *
            -- `panShift` in that direction.
            visibleCells
                |> toFloat
                |> (*) viewConfig.panShift
                |> floor

        ( x, y ) =
            viewConfig.topLeft

        newTopLeft =
            case direction of
                Up ->
                    ( x, y - topLeftShift )

                Down ->
                    ( x, y + topLeftShift )

                Left ->
                    ( x - topLeftShift, y )

                Right ->
                    ( x + topLeftShift, y )
    in
        { viewConfig | topLeft = newTopLeft }
