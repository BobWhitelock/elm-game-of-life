module Tests exposing (..)

import Test exposing (..)
import Expect
import Set
import String
import Cell


-- TODO: Work out how to have multiple test files.
-- TODO: Need to duplicate main app dependencies for `tests` dir?


all : Test
all =
    describe "Cell"
        [ describe "neighbours"
            [ test "returns all neighbouring Cells" <|
                \() ->
                    let
                        neighbours =
                            Set.fromList
                                [ ( 0, 0 )
                                , ( 0, 1 )
                                , ( 0, 2 )
                                , ( 1, 0 )
                                , ( 1, 2 )
                                , ( 2, 0 )
                                , ( 2, 1 )
                                , ( 2, 2 )
                                ]
                    in
                        Expect.equal neighbours (Cell.neighbours ( 1, 1 ))
            ]
        , describe "activeCells"
            [ test "returns all living Cells and their neighbours" <|
                \() ->
                    let
                        cells =
                            Set.fromList [ ( 1, 1 ), ( 5, 5 ) ]

                        activeCells =
                            Set.fromList
                                [ ( 0, 0 )
                                , ( 0, 1 )
                                , ( 0, 2 )
                                , ( 1, 0 )
                                , ( 1, 1 )
                                , ( 1, 2 )
                                , ( 2, 0 )
                                , ( 2, 1 )
                                , ( 2, 2 )
                                , ( 0, 0 )
                                , ( 0, 1 )
                                , ( 0, 2 )
                                , ( 1, 0 )
                                , ( 1, 2 )
                                , ( 2, 0 )
                                , ( 2, 1 )
                                , ( 2, 2 )
                                , ( 4, 4 )
                                , ( 4, 5 )
                                , ( 4, 6 )
                                , ( 5, 4 )
                                , ( 5, 5 )
                                , ( 5, 6 )
                                , ( 6, 4 )
                                , ( 6, 5 )
                                , ( 6, 6 )
                                ]
                    in
                        Expect.equal activeCells (Cell.activeCells cells)
            ]
        , describe "livingNeighbours"
            [ test "returns Cell neighbours which are in the given livingCells Set" <|
                \() ->
                    let
                        livingCells =
                            Set.fromList [ ( 1, 1 ), ( 1, 2 ), ( 10, 10 ) ]

                        livingNeighbours =
                            Set.fromList [ ( 1, 1 ), ( 1, 2 ) ]
                    in
                        Expect.equal
                            livingNeighbours
                            (Cell.livingNeighbours livingCells ( 2, 1 ))
            ]
        , describe "nextLivingCells"
            [ test "any live cell with fewer than two live neighbours dies" <|
                \() ->
                    let
                        livingCells =
                            Set.fromList [ ( 1, 1 ), ( 2, 2 ) ]
                    in
                        expectCellToBeDead livingCells
            , test "any live cell with two live neighbours lives on to the next generation" <|
                \() ->
                    let
                        livingCells =
                            Set.fromList [ ( 0, 0 ), ( 1, 1 ), ( 2, 2 ) ]
                    in
                        expectCellToBeAlive livingCells
            , test "any live cell with three live neighbours lives on to the next generation" <|
                \() ->
                    let
                        livingCells =
                            Set.fromList [ ( 0, 0 ), ( 1, 1 ), ( 2, 2 ), ( 0, 1 ) ]
                    in
                        expectCellToBeAlive livingCells
            , test "any live cell with more than three live neighbours dies" <|
                \() ->
                    let
                        livingCells =
                            Set.fromList [ ( 0, 0 ), ( 1, 1 ), ( 2, 2 ), ( 0, 1 ), ( 1, 0 ) ]
                    in
                        expectCellToBeDead livingCells
            , test "any dead cell with exactly three live neighbours becomes a live cell" <|
                \() ->
                    let
                        livingCells =
                            Set.fromList [ ( 0, 0 ), ( 2, 2 ), ( 2, 0 ) ]
                    in
                        expectCellToBeAlive livingCells
            ]
        , describe "isVisible"
            -- TODO: May be better test values can use here - use fuzz testing?
            [ test "a Cell within the bounding Cells is visible" <|
                \() ->
                    expectCellToBeVisible ( 17, 17 )
            , test "a Cell outside the bounding Cells is not visible" <|
                \() ->
                    expectCellToNotBeVisible ( 5, 25 )
            , test "another Cell outside the bounding Cells is not visible" <|
                \() ->
                    expectCellToNotBeVisible ( 25, 5 )
            , test "a Cell on the border with the bounding Cells is visible" <|
                \() ->
                    expectCellToBeVisible ( 10, 20 )
            ]
        ]


expectCellToBeAlive livingCells =
    cellInNextLivingCells livingCells
        |> Expect.true "Expected (1, 1) to be alive."


expectCellToBeDead livingCells =
    cellInNextLivingCells livingCells
        |> Expect.false "Expected (1, 1) to be dead."


cellInNextLivingCells livingCells =
    Cell.nextLivingCells livingCells
        |> Set.member ( 1, 1 )


expectCellToBeVisible cell =
    Cell.isVisible ( 10, 10 ) ( 20, 20 ) cell
        |> Expect.true "Expected Cell to be visible."


expectCellToNotBeVisible cell =
    Cell.isVisible ( 10, 10 ) ( 20, 20 ) cell
        |> Expect.false "Expected Cell to not be visible."
