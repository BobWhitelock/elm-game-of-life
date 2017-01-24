module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model)
import GameView
import ZoomLevel
import TickPeriod


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
            , gameInfo model
            , gameControls model
            , panControls model
            , zoomControls model
            ]


gameInfo : Model -> Html Msg
gameInfo model =
    let
        iterationNumber =
            toString (model.ticks)

        frequency =
            TickPeriod.frequency model.tickPeriod
                |> floor
                |> toString

        info =
            -- TODO: handle singular case for 'iterations'.
            "Iteration "
                ++ iterationNumber
                ++ " | "
                ++ frequency
                ++ " iterations / second"
    in
        div [] [ text info ]


gameControls : Model -> Html Msg
gameControls model =
    let
        runButtonText =
            if model.running then
                "Pause"
            else
                "Run"
    in
        div []
            [ button
                [ onClick DecreaseSpeed
                , disabled (TickPeriod.isMinimumSpeed model.tickPeriod)
                ]
                [ text "<<" ]
            , button
                [ onClick ToggleRunning ]
                [ text runButtonText ]
            , button
                [ onClick IncreaseSpeed
                , disabled (TickPeriod.isMaximumSpeed model.tickPeriod)
                ]
                [ text ">>" ]
            ]


panControls : Model -> Html Msg
panControls model =
    div []
        [ text "Pan:"
        , button
            [ onClick (Pan Up) ]
            [ text "/\\" ]
        , button
            [ onClick (Pan Down) ]
            [ text "\\/" ]
        , button
            [ onClick (Pan Left) ]
            [ text "<" ]
        , button
            [ onClick (Pan Right) ]
            [ text ">" ]
        ]


zoomControls : Model -> Html Msg
zoomControls model =
    div []
        [ text "Zoom:"
        , button
            [ onClick ZoomIn
            , disabled (ZoomLevel.isMaximum model.viewConfig.zoomLevel)
            ]
            [ text "+" ]
        , button
            [ onClick ZoomOut
            , disabled (ZoomLevel.isMinimum model.viewConfig.zoomLevel)
            ]
            [ text "-" ]
        ]
