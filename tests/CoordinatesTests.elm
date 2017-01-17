module CoordinatesTests exposing (all)

import Test exposing (..)
import Fuzz
import Expect
import Coordinates exposing (..)
import ViewConfig exposing (defaultConfig)
import ZoomLevel


all : Test
all =
    describe "Coordinates"
        -- These tests are probably too dependent on `defaultConfig`, they will
        -- most likely break if it changes.
        [ describe "toCell"
            [ test "when Coordinates within bounds it returns the correct Cell" <|
                \() ->
                    let
                        coordinates =
                            ( 25, 36 )

                        cell =
                            toCell defaultConfig coordinates
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
                            List.map (toCell defaultConfig) coordinates
                    in
                        Expect.equal nothings cells
            , fuzz2 Fuzz.int
                Fuzz.int
                "when reversed gives Nothing or top left Coordinates of containing Cell"
              <|
                \xCoordinate yCoordinate ->
                    let
                        coordinates =
                            ( xCoordinate, yCoordinate )

                        failedMessage =
                            "Expected toCell "
                                ++ toString coordinates
                                ++ " |> fromCell to be Nothing or Just "
                                ++ toString containingCellCoordinates
                                ++ " (the top left coordinates of the containing Cell)"

                        containingCellCoordinates =
                            let
                                rounded =
                                    \a -> a - (a % defaultConfig.cellSize)

                                x =
                                    rounded xCoordinate

                                y =
                                    rounded yCoordinate
                            in
                                ( x, y )
                    in
                        toCell defaultConfig coordinates
                            |> Maybe.map (fromCell defaultConfig)
                            |> (flip List.member) [ Nothing, Just containingCellCoordinates ]
                            |> Expect.true failedMessage
            ]
        , describe "fromCell"
            [ test "returns the correct top left Coordinates of each Cell" <|
                \() ->
                    let
                        cells =
                            [ ( 0, 0 ), ( 3, 5 ), ( -100, 123 ) ]

                        expectedCoordinates =
                            [ ( 0, 0 ), ( 30, 50 ), ( -1000, 1230 ) ]

                        resultingCoordinates =
                            List.map (fromCell defaultConfig) cells
                    in
                        Expect.equal expectedCoordinates resultingCoordinates
            , fuzz2 Fuzz.int
                Fuzz.int
                "when reversed gives Nothing or Just cell"
              <|
                \cellX cellY ->
                    let
                        cell =
                            ( cellX, cellY )

                        failedMessage =
                            "Expected fromCell "
                                ++ toString cell
                                ++ " |> toCell to be Nothing or Just "
                                ++ toString cell
                    in
                        fromCell defaultConfig cell
                            |> toCell defaultConfig
                            |> (flip List.member) [ Nothing, Just cell ]
                            |> Expect.true failedMessage
            ]
        ]
