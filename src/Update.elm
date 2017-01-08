module Update exposing (update)

import Set exposing (Set)
import Model exposing (Model)
import Cell exposing (..)
import Coordinates exposing (Coordinates)
import Messages exposing (..)
import ViewConfig exposing (config)
import Utils


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

        modelWithMouseClick =
            updateLastMouseClick model coordinates
    in
        if model.running then
            ( modelWithMouseClick, Cmd.none )
        else
            case maybeCell of
                Just cell ->
                    ( { modelWithMouseClick
                        | livingCells = Utils.toggleIn model.livingCells cell
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( modelWithMouseClick, Cmd.none )


updateLastMouseClick : Model -> Coordinates -> Model
updateLastMouseClick model coordinates =
    { model | lastMouseClick = coordinates }
