module UpdateViewConfigTests exposing (all)

import Test exposing (..)
import Expect
import UpdateViewConfig exposing (..)
import ViewConfig exposing (ViewConfig)
import ZoomLevel


all : Test
all =
    describe "UpdateViewConfig"
        [ describe "zoom"
            [ test "new zoomLevel is current changed by changeZoom" <|
                \() ->
                    let
                        changeZoom =
                            ZoomLevel.zoomIn

                        newZoomLevel =
                            zoom changeZoom viewConfig |> .zoomLevel
                    in
                        Expect.equal (changeZoom viewConfig.zoomLevel) newZoomLevel
            , test "topLeft Cell is shifted inwards correctly when zoom in" <|
                \() ->
                    let
                        newTopLeftCell =
                            zoom ZoomLevel.zoomIn viewConfig |> .topLeft
                    in
                        Expect.equal ( -1, -11 ) newTopLeftCell
            , test "topLeft Cell is shifted outwards correctly when zoom out" <|
                \() ->
                    let
                        newTopLeftCell =
                            zoom ZoomLevel.zoomOut viewConfig |> .topLeft
                    in
                        Expect.equal ( -28, -38 ) newTopLeftCell
            ]
        ]


viewConfig : ViewConfig
viewConfig =
    let
        default =
            ViewConfig.defaultConfig
    in
        { default
            | topLeft =
                ( -10, -20 )
                -- Values carefully chosen so `visibleCells` == 36 for nice
                -- round numbers in tests.
            , borderSize = 0
            , svgSize = 360
        }
