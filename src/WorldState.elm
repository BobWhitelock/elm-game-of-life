module WorldState
    exposing
        ( WorldState
        , State(..)
        , fromExistingCells
        , cellsWithState
        , livingCells
        , toggleCellState
        )

import Dict exposing (Dict)
import Set exposing (Set)
import Tuple
import Cell exposing (Cell)


type alias WorldState =
    Dict Cell State


type State
    = Existing
    | New
    | Deleted


fromExistingCells : Set Cell -> WorldState
fromExistingCells cells =
    Set.toList cells
        |> List.map (\cell -> ( cell, Existing ))
        |> Dict.fromList


cellsWithState : State -> WorldState -> Set Cell
cellsWithState neededState worldState =
    let
        cellHasState =
            \cell -> \cellState -> cellState == neededState
    in
        filterCells cellHasState worldState


livingCells : WorldState -> Set Cell
livingCells worldState =
    let
        cellIsAlive =
            \cell ->
                \cellState ->
                    List.member cellState [ Existing, New ]
    in
        filterCells cellIsAlive worldState


filterCells : (Cell -> State -> Bool) -> WorldState -> Set Cell
filterCells filter worldState =
    Dict.filter filter worldState
        |> Dict.toList
        |> List.map Tuple.first
        |> Set.fromList


toggleCellState : Cell -> WorldState -> WorldState
toggleCellState cell worldState =
    let
        cellState =
            Dict.get cell worldState

        changeState =
            \newState ->
                Maybe.map (\state -> newState)
    in
        case cellState of
            Just Existing ->
                Dict.update cell (changeState Deleted) worldState

            Just Deleted ->
                Dict.update cell (changeState Existing) worldState

            Just New ->
                Dict.remove cell worldState

            Nothing ->
                Dict.insert cell New worldState
