module Update exposing (update)

import Model exposing (Model)
import Cell exposing (..)
import Coordinates exposing (Coordinates)
import Messages exposing (..)
import ViewConfig
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

        ZoomOut ->
            let
                modelWithNewZoomLevel =
                    multiplyZoomLevel 0.5 model
            in
                if (modelWithNewZoomLevel.viewConfig.zoomLevel >= ViewConfig.minimumZoomLevel) then
                    ( modelWithNewZoomLevel, Cmd.none )
                else
                    ( model, Cmd.none )

        ZoomIn ->
            let
                modelWithNewZoomLevel =
                    multiplyZoomLevel 2 model
            in
                if (modelWithNewZoomLevel.viewConfig.zoomLevel <= ViewConfig.maximumZoomLevel) then
                    ( modelWithNewZoomLevel, Cmd.none )
                else
                    ( model, Cmd.none )


multiplyZoomLevel : Float -> Model -> Model
multiplyZoomLevel multiplier currentModel =
    let
        currentViewConfig =
            currentModel.viewConfig

        newViewConfig =
            { currentViewConfig
                | zoomLevel =
                    currentViewConfig.zoomLevel * multiplier
            }
    in
        { currentModel | viewConfig = newViewConfig }


handleMouseClick : Model -> Coordinates -> ( Model, Cmd Msg )
handleMouseClick model coordinates =
    let
        maybeCell =
            Coordinates.cellAtCoordinates model.viewConfig coordinates

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
