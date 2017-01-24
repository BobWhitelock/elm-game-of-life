module UpdateViewConfig exposing (zoom)

import ViewConfig exposing (ViewConfig)
import ZoomLevel exposing (ZoomLevel)


zoom : (ZoomLevel -> ZoomLevel) -> ViewConfig -> ViewConfig
zoom changeZoom viewConfig =
    let
        newViewConfig =
            { viewConfig
                | zoomLevel =
                    changeZoom viewConfig.zoomLevel
            }
    in
        newViewConfig
