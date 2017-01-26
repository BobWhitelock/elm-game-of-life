module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model)
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
        [ div [] [ panUpButton ]
        , div
            [ Styles.game
            ]
            [ div [ Styles.sidePanButton ] [ panLeftButton ]
            , GameView.gameView model
            , div [ Styles.sidePanButton ] [ panRightButton ]
            ]
        , div [] [ panDownButton ]
        ]


panUpButton =
    panButton Up "/\\"


panDownButton =
    panButton Down "\\/"


panLeftButton =
    panButton Left "<"


panRightButton =
    panButton Right ">"


panButton direction icon =
    button
        [ onClick (Pan direction) ]
        [ text icon ]


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
        runButtonText =
            if model.running then
                "Pause"
            else
                "Run"
    in
        div [ Styles.controlPanelSection ]
            [ iterationInfo model
            , div []
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
                [ text "+" ]
            , button
                [ onClick ZoomOut
                , disabled (ZoomLevel.isMinimum model.viewConfig.zoomLevel)
                ]
                [ text "-" ]
            ]
        ]
