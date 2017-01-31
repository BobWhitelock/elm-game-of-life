module View exposing (view)

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model, Icons)
import GameView
import ZoomLevel
import TickPeriod
import Styles


view : Model -> Html Msg
view model =
    let
        runButtonText =
            if model.running then
                "Pause"
            else
                "Run"
    in
        div
            [ Styles.windowWrapper ]
            [ div [ Styles.centredPage ]
                [ game model
                , controlPanel model
                ]
            ]


game model =
    div [ Styles.gameColumn ]
        [ div [] [ panUpButton model ]
        , div
            [ Styles.game
            ]
            [ div [ Styles.sidePanButton ] [ panLeftButton model ]
            , GameView.gameView model
            , div [ Styles.sidePanButton ] [ panRightButton model ]
            ]
        , div [] [ panDownButton model ]
        ]


panUpButton model =
    panButton model Up "arrow-up"


panDownButton model =
    panButton model Down "arrow-down"


panLeftButton model =
    panButton model Left "arrow-left"


panRightButton model =
    panButton model Right "arrow-right"


panButton model direction iconName =
    button
        [ onClick (Pan direction) ]
        [ icon model.icons iconName ]


controlPanel model =
    div
        [ Styles.controlPanelColumn
        ]
        [ div
            [ Styles.controlPanelInside model.viewConfig
            ]
            [ gameControls model
            , zoomControls model
            ]
        ]


gameControls : Model -> Html Msg
gameControls model =
    let
        runButtonIcon =
            if model.running then
                "pause"
            else
                "play"
    in
        div [ Styles.controlPanelSection ]
            [ iterationInfo model
            , div []
                [ button
                    [ onClick DecreaseSpeed
                    , disabled (TickPeriod.isMinimumSpeed model.tickPeriod)
                    ]
                    [ icon model.icons "rewind" ]
                , button
                    [ onClick ToggleRunning ]
                    [ icon model.icons runButtonIcon ]
                , button
                    [ onClick IncreaseSpeed
                    , disabled (TickPeriod.isMaximumSpeed model.tickPeriod)
                    ]
                    [ icon model.icons "fast-forward" ]
                ]
            , iterationFrequencyInfo model
            ]


iterationInfo model =
    let
        iterationNumber =
            toString (model.ticks)
    in
        div []
            [ text ("Iteration " ++ iterationNumber)
            ]


iterationFrequencyInfo model =
    let
        frequency =
            TickPeriod.frequency model.tickPeriod
                |> floor
                |> toString
    in
        div []
            -- TODO: handle singular case for 'iterations'.
            [ text (frequency ++ " iterations / second")
            ]


zoomControls : Model -> Html Msg
zoomControls model =
    div [ Styles.controlPanelSection ]
        [ div []
            [ text "Zoom:"
            , button
                [ onClick ZoomIn
                , disabled (ZoomLevel.isMaximum model.viewConfig.zoomLevel)
                ]
                [ icon model.icons "plus" ]
            , button
                [ onClick ZoomOut
                , disabled (ZoomLevel.isMinimum model.viewConfig.zoomLevel)
                ]
                [ icon model.icons "minus" ]
            ]
        ]


icon : Icons -> String -> Html Msg
icon icons iconName =
    let
        icon =
            Dict.get iconName icons
                |> Maybe.withDefault ""
    in
        img [ src icon, width 20 ] []
