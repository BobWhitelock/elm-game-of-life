module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model)
import GameView
import ViewConfig


view : Model -> Html Msg
view model =
    let
        runButtonText =
            if model.running then
                "Pause"
            else
                "Run"
    in
        div []
            [ GameView.gameView model
            , button
                [ onClick ToggleRunning ]
                [ text runButtonText ]
            , button
                [ onClick ZoomIn
                , disabled (model.viewConfig.zoomLevel >= ViewConfig.maximumZoomLevel)
                ]
                [ text "+" ]
            , button
                [ onClick ZoomOut
                , disabled (model.viewConfig.zoomLevel <= ViewConfig.minimumZoomLevel)
                ]
                [ text "-" ]
            ]
