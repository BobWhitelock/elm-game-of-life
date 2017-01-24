module UpdateViewConfig exposing (zoom)

import ViewConfig exposing (ViewConfig)
import ZoomLevel exposing (ZoomLevel)


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
