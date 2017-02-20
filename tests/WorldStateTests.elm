module WorldStateTests exposing (all)

import Test exposing (..)
import Fuzz
import Expect
import Set
import Dict
import Tuple
import Maybe
import WorldState exposing (..)


all : Test
all =
    describe "WorldState"
        [ describe "fromExistingCells" <|
            [ fuzz cellListFuzzer
                "creates WorldState of just Existing Cells"
              <|
                \cellList ->
                    let
                        cells =
                            Set.fromList cellList
                    in
                        Expect.equal cells
                            (fromExistingCells cells |> cellsWithState Existing)
            ]
        ]


cellListFuzzer =
    ( Fuzz.int, Fuzz.int )
        |> Fuzz.tuple
        |> Fuzz.list
