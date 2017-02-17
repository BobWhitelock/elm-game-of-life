module View exposing (view)

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Messages exposing (..)
import Model exposing (Model, Icons)
import GameView
import ZoomLevel exposing (ZoomLevel)
import TickPeriod
import Styles.Classes as Classes
import Styles.Inline


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


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
            [ class [ Classes.WindowWrapper ] ]
            [ div [ class [ Classes.CentredPage ] ]
                [ game model
                , controlPanel model
                ]
            ]


game model =
    div [ class [ Classes.GameColumn ] ]
        [ div [] [ panUpButton model ]
        , div
            [ class [ Classes.Game ]
            ]
            [ div [ class [ Classes.SidePanButton ] ] [ panLeftButton model ]
            , GameView.gameView model
            , div [ class [ Classes.SidePanButton ] ] [ panRightButton model ]
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
        [ class [ Classes.ControlPanelColumn ]
        ]
        [ div
            [ class [ Classes.ControlPanelInside ]
            , Styles.Inline.controlPanelInside model.viewConfig
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
        div [ class [ Classes.ControlPanelSection ] ]
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
    div [ class [ Classes.ControlPanelSection ] ]
        [ div [ class [ Classes.ZoomControls ] ]
            [ zoomButton model ZoomIn "plus" ZoomLevel.isMaximum
            , zoomButton model ZoomOut "minus" ZoomLevel.isMinimum
            ]
        ]


zoomButton : Model -> Msg -> String -> (ZoomLevel -> Bool) -> Html Msg
zoomButton model msg iconName atLimit =
    button
        [ onClick msg
        , disabled (atLimit model.viewConfig.zoomLevel)
        , class [ Classes.ZoomButton ]
        ]
        [ icon model.icons iconName ]


icon : Icons -> String -> Html Msg
icon icons iconName =
    let
        icon =
            Dict.get iconName icons
                |> Maybe.withDefault ""
    in
        img [ src icon, width 20 ] []
