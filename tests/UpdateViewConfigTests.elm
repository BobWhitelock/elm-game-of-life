module UpdateViewConfigTests exposing (all)

import Test exposing (..)
import Expect
import UpdateViewConfig exposing (..)
import ViewConfig exposing (ViewConfig)
import ZoomLevel
import Messages exposing (Direction(..))
import Coordinates exposing (Coordinates)


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
        , describe "pan"
            [ test "when Up, topLeft is shifted 50% up" <|
                \() ->
                    let
                        newTopLeftCell =
                            topLeftAfterPan Up
                    in
                        Expect.equal ( -10, -38 ) newTopLeftCell
            , test "when Down, topLeft is shifted 50% down" <|
                \() ->
                    let
                        newTopLeftCell =
                            topLeftAfterPan Down
                    in
                        Expect.equal ( -10, -2 ) newTopLeftCell
            , test "when Left, topLeft is shifted 50% left" <|
                \() ->
                    let
                        newTopLeftCell =
                            topLeftAfterPan Left
                    in
                        Expect.equal ( -28, -20 ) newTopLeftCell
            , test "when Right, topLeft is shifted 50% right" <|
                \() ->
                    let
                        newTopLeftCell =
                            topLeftAfterPan Right
                    in
                        Expect.equal ( 8, -20 ) newTopLeftCell
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


topLeftAfterPan : Direction -> Coordinates
topLeftAfterPan direction =
    pan direction viewConfig |> .topLeft
