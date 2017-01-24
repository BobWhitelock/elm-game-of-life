module UpdateViewConfigTests exposing (all)

import Test exposing (..)
import Expect
import UpdateViewConfig exposing (..)
import ViewConfig
import ZoomLevel


all : Test
all =
    describe "UpdateViewConfig"
        [ describe "zoom"
            [ test "new zoomLevel is current changed by changeZoom" <|
                \() ->
                    let
                        viewConfig =
                            ViewConfig.defaultConfig

                        changeZoom =
                            ZoomLevel.zoomIn

                        newZoomLevel =
                            zoom changeZoom viewConfig |> .zoomLevel
                    in
                        Expect.equal (changeZoom viewConfig.zoomLevel) newZoomLevel
            ]
        ]
