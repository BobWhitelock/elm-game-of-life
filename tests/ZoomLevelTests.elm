module ZoomLevelTests exposing (all)

import Test exposing (..)
import Expect
import ZoomLevel exposing (..)


all : Test
all =
    describe "ZoomLevel"
        [ describe "scale"
            [ test "initial ZoomLevel returns 1" <|
                \() ->
                    let
                        zoomLevel =
                            initial
                    in
                        Expect.equal 1 (scale zoomLevel)
            , test "1 level closer in the ZoomLevel returns 2" <|
                \() ->
                    let
                        zoomLevel =
                            zoomIn initial
                    in
                        Expect.equal 2 (scale zoomLevel)
            , test "1 level further out the ZoomLevel returns 0.5" <|
                \() ->
                    let
                        zoomLevel =
                            zoomOut initial
                    in
                        Expect.equal 0.5 (scale zoomLevel)
            , test "3 levels further out the ZoomLevel returns 0.125" <|
                \() ->
                    let
                        zoomLevel =
                            initial |> zoomOut |> zoomOut |> zoomOut
                    in
                        Expect.equal 0.125 (scale zoomLevel)
            ]
        , describe "zoomIn"
            [ test "can only zoom in once from initial" <|
                \() ->
                    Expect.equal (zoomIn initial) (initial |> zoomIn |> zoomIn)
            ]
        , describe "zoomOut"
            [ test "can only zoom out three times from initial" <|
                \() ->
                    let
                        threeZooms =
                            initial |> zoomOut |> zoomOut |> zoomOut

                        fourZooms =
                            threeZooms |> zoomOut
                    in
                        Expect.equal threeZooms fourZooms
            ]
        , test "can zoom in and out many times and get consistent result" <|
            \() ->
                let
                    manyZooms =
                        initial
                            |> zoomOut
                            |> zoomIn
                            |> zoomOut
                            |> zoomIn
                in
                    Expect.equal initial manyZooms
        , describe "isMaximum"
            [ test "returns true at maximum zoom" <|
                \() ->
                    Expect.equal True (initial |> zoomIn |> isMaximum)
            , test "returns false otherwise" <|
                \() ->
                    Expect.equal False (initial |> isMaximum)
            ]
        , describe "isMinimum"
            [ test "returns true at minimum zoom" <|
                \() ->
                    Expect.equal True (initial |> zoomOut |> zoomOut |> zoomOut |> isMinimum)
            , test "returns false otherwise" <|
                \() ->
                    Expect.equal False (initial |> zoomOut |> isMinimum)
            ]
        ]
