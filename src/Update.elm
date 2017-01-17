module Update exposing (update)

import Model exposing (Model)
import Cell exposing (..)
import Coordinates exposing (Coordinates)
import Messages exposing (..)
import Utils
import ZoomLevel exposing (ZoomLevel)
import TickPeriod


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
            ( zoom ZoomLevel.zoomOut model, Cmd.none )

        ZoomIn ->
            ( zoom ZoomLevel.zoomIn model, Cmd.none )

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


zoom : (ZoomLevel -> ZoomLevel) -> Model -> Model
zoom changeZoom model =
    let
        currentViewConfig =
            model.viewConfig

        newViewConfig =
            { currentViewConfig
                | zoomLevel =
                    changeZoom currentViewConfig.zoomLevel
            }
    in
        { model | viewConfig = newViewConfig }


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
