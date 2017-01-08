module View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model)
import GameView


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
                [ onClick ZoomIn ]
                [ text "+" ]
            , button
                [ onClick ZoomOut ]
                [ text "-" ]
            ]
