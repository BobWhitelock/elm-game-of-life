module CoordinatesTests exposing (..)

import Test exposing (..)
import Expect
import Coordinates


-- TODO: more test cases for some branches?


all : Test
all =
    describe "Coordinates"
        [ describe "cellAtCoordinates"
            [ test "returns correct Cell when no border" <|
                \() ->
                    let
                        config =
                            { borderSize = 0
                            , cellSize = 10
                            , visibleCells = 2
                            }

                        coordinates =
                            ( 15, 5 )

                        cell =
                            Coordinates.cellAtCoordinates config coordinates
                    in
                        Expect.equal (Just ( 1, 0 )) cell
            , test "returns Nothing when no border and Coordinates outside of visible grid" <|
                \() ->
                    let
                        config =
                            { borderSize = 0
                            , cellSize = 10
                            , visibleCells = 2
                            }

                        badCoordinates =
                            [ ( 25, 25 ), ( -5, 10 ), ( 20, 20 ), ( 0, 0 ) ]

                        cells =
                            List.map (Coordinates.cellAtCoordinates config) badCoordinates

                        nothings =
                            List.repeat (List.length badCoordinates) Nothing
                    in
                        Expect.equal nothings cells
              -- TODO: needed?
              -- , test "returns Nothing when Coordinates on boundary between Cells, i.e. ambiguous" <|
              --     \() ->
              --         let
              --             config =
              --                 { borderSize = 0
              --                 , cellSize = 10
              --                 , visibleCells = 2
              --                 }
              --             badCoordinates =
              --                 [ ( 5, 10 ) ]
              --             cells =
              --                 List.map (Coordinates.cellAtCoordinates config) badCoordinates
              --             nothings =
              --                 List.repeat (List.length badCoordinates) Nothing
              --         in
              --             Expect.equal nothings cells
            , test "returns correct Cell when border" <|
                \() ->
                    let
                        config =
                            { borderSize = 17
                            , cellSize = 10
                            , visibleCells = 2
                            }

                        -- badCoordinates =
                        --     [ ( 25, 25 ), ( -5, 10 ), ( 20, 20 ), ( 0, 0 ) ]
                        coordinates =
                            ( 22, 30 )

                        cell =
                            Coordinates.cellAtCoordinates config coordinates

                        -- cells =
                        --     List.map (Coordinates.cellAtCoordinates config) badCoordinates
                        -- nothings =
                        --     List.repeat (List.length badCoordinates) Nothing
                    in
                        Expect.equal (Just ( 0, 1 )) cell
            ]
        ]
