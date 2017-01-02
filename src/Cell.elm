module Cell
    exposing
        ( Cell
        , nextLivingCells
        , neighbours
        , livingNeighbours
        , activeCells
        )

import Set exposing (Set)


type alias Cell =
    ( Int, Int )


nextLivingCells : Set Cell -> Set Cell
nextLivingCells livingCells =
    let
        cellIsAlive =
            isAlive livingCells

        willBeAlive =
            \cell ->
                let
                    currentCellIsAlive =
                        cellIsAlive cell

                    numberLivingNeighbours =
                        (livingNeighbours livingCells cell) |> Set.size

                    hasLivingNeighboursIn =
                        \list ->
                            List.member numberLivingNeighbours list

                    staysAlive =
                        currentCellIsAlive && hasLivingNeighboursIn [ 2, 3 ]

                    comesAlive =
                        not currentCellIsAlive && hasLivingNeighboursIn [ 3 ]
                in
                    staysAlive || comesAlive
    in
        Set.filter willBeAlive (activeCells livingCells)


neighbours : Cell -> Set Cell
neighbours cell =
    let
        deltas =
            [ ( -1, -1 )
            , ( -1, 0 )
            , ( -1, 1 )
            , ( 0, -1 )
            , ( 0, 1 )
            , ( 1, -1 )
            , ( 1, 0 )
            , ( 1, 1 )
            ]
    in
        List.map (add cell) deltas
            |> Set.fromList


livingNeighbours : Set Cell -> Cell -> Set Cell
livingNeighbours livingCells cell =
    Set.filter (isAlive livingCells) (neighbours cell)


isAlive : Set Cell -> Cell -> Bool
isAlive livingCells cell =
    Set.member cell livingCells


activeCells : Set Cell -> Set Cell
activeCells livingCells =
    let
        collectNeighbours =
            \cell ->
                \collected ->
                    Set.union collected (neighbours cell)

        allNeighbours =
            Set.foldl collectNeighbours Set.empty livingCells
    in
        Set.union allNeighbours livingCells


add : Cell -> Cell -> Cell
add ( x1, y1 ) ( x2, y2 ) =
    ( x1 + x2, y1 + y2 )
