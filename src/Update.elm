module Update exposing (update)

import Model exposing (Model)
import Cell exposing (..)
import Coordinates exposing (Coordinates)
import Messages exposing (..)
import Utils
import ZoomLevel exposing (ZoomLevel)
import TickPeriod
import UpdateViewConfig


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
                , ticks = model.ticks + 1
              }
            , Cmd.none
            )

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


handleMouseClick : Model -> Coordinates -> ( Model, Cmd Msg )
handleMouseClick model coordinates =
    let
        maybeCell =
            Coordinates.toCell model.viewConfig coordinates

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
