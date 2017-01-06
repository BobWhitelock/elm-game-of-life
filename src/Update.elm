module Update exposing (update)

import Set exposing (Set)
import Model exposing (Model)
import Cell exposing (..)
import Coordinates exposing (Coordinates)
import Messages exposing (..)
import ViewConfig exposing (config)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleRunning ->
            ( { model
                | running = not model.running
              }
            , Cmd.none
            )

        Tick _ ->
            ( { model
                | livingCells = nextLivingCells model.livingCells
              }
            , Cmd.none
            )

        MouseClick coordinates ->
            handleMouseClick model coordinates


handleMouseClick : Model -> Coordinates -> ( Model, Cmd Msg )
handleMouseClick model coordinates =
    let
        maybeCell =
            Coordinates.cellAtCoordinates config coordinates
    in
        if model.running then
            ( model, Cmd.none )
        else
            case maybeCell of
                Just cell ->
                    ( { model
                        | livingCells = toggleCellIn model.livingCells cell
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )


toggleCellIn : Set Cell -> Cell -> Set Cell
toggleCellIn cells cell =
    if Set.member cell cells then
        Set.remove cell cells
    else
        Set.insert cell cells
