module CoordinatesTests exposing (all)

import Test exposing (..)
import Expect
import Coordinates exposing (..)
import ViewConfig exposing (defaultConfig)
import ZoomLevel


all : Test
all =
    describe "Coordinates"
        -- These tests are probably too dependent on `defaultConfig`, they will
        -- most likely break if it changes.
        [ describe "cellAtCoordinates"
            [ test
                "when Coordinates within bounds it returns the correct Cell"
              <|
                \() ->
                    let
                        coordinates =
                            ( 25, 36 )

                        cell =
                            cellAtCoordinates defaultConfig coordinates
                    in
                        Expect.equal (Just ( 2, 3 )) cell
            , test "when Coordinates outside bounds it returns Nothing" <|
                \() ->
                    let
                        coordinateOnEdge =
                            defaultConfig.cellSize
                                * ViewConfig.visibleCells defaultConfig

                        coordinates =
                            [ ( -6, -12 )
                            , ( 25, coordinateOnEdge )
                            , ( 0, 0 )
                            ]

                        nothings =
                            List.repeat (List.length coordinates) Nothing

                        cells =
                            List.map
                                (cellAtCoordinates defaultConfig)
                                coordinates
                    in
                        Expect.equal nothings cells
            ]
        ]
