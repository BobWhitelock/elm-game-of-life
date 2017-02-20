module Update exposing (update)

import List.Nonempty exposing ((:::))
import Model exposing (Model)
import Cell
import Coordinates exposing (Coordinates)
import Messages exposing (..)
import ZoomLevel exposing (ZoomLevel)
import TickPeriod
import UpdateViewConfig
import WorldState


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
            nextState model

        MouseClick coordinates ->
            handleMouseClick model coordinates

        ZoomOut ->
            ( { model
                | viewConfig =
                    UpdateViewConfig.zoom ZoomLevel.zoomOut model.viewConfig
              }
            , Cmd.none
            )

        ZoomIn ->
            ( { model
                | viewConfig =
                    UpdateViewConfig.zoom ZoomLevel.zoomIn model.viewConfig
              }
            , Cmd.none
            )

        Pan direction ->
            ( { model
                | viewConfig =
                    UpdateViewConfig.pan direction model.viewConfig
              }
            , Cmd.none
            )

        DecreaseSpeed ->
            ( { model
                | tickPeriod = TickPeriod.decreaseSpeedIfPossible model.tickPeriod
              }
            , Cmd.none
            )

        IncreaseSpeed ->
            ( { model
                | tickPeriod = TickPeriod.increaseSpeedIfPossible model.tickPeriod
              }
            , Cmd.none
            )

        PreviousState ->
            ( { model | history = List.Nonempty.pop model.history }
            , Cmd.none
            )

        NextState ->
            nextState model


handleMouseClick : Model -> Coordinates -> ( Model, Cmd Msg )
handleMouseClick model coordinates =
    let
        maybeCell =
            Coordinates.toCell model.viewConfig coordinates

        modelWithMouseClick =
            updateLastMouseClick model coordinates

        toggleLivingCell cell =
            List.Nonempty.head model.history
                |> WorldState.toggleCellState cell
                |> (flip List.Nonempty.replaceHead) model.history
    in
        if model.running then
            ( modelWithMouseClick, Cmd.none )
        else
            case maybeCell of
                Just cell ->
                    ( { modelWithMouseClick
                        | history = toggleLivingCell cell
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( modelWithMouseClick, Cmd.none )


nextState : Model -> ( Model, Cmd Msg )
nextState model =
    let
        currentLivingCells =
            List.Nonempty.head model.history
                |> WorldState.livingCells

        newHistory =
            Cell.nextLivingCells currentLivingCells
                |> WorldState.fromExistingCells
                |> (flip List.Nonempty.cons) model.history
    in
        ( { model | history = newHistory }
        , Cmd.none
        )


updateLastMouseClick : Model -> Coordinates -> Model
updateLastMouseClick model coordinates =
    { model | lastMouseClick = coordinates }
