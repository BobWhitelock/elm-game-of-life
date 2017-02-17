module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Html.Attributes


type Classes
    = WindowWrapper
    | CentredPage
    | GameColumn
    | Game
    | SidePanButton
    | ControlPanelColumn
    | ControlPanelInside
    | ControlPanelSection
    | ZoomControls
    | ZoomButton


css =
    stylesheet
        [ body
            [ margin zero
            , textAlign center
            , fontSize (px 30)
            , fontFamilies
                [ "Source Sans Pro"
                , "Trebuchet MS"
                , "Lucida Grande"
                , "Bitstream Vera Sans"
                , "Helvetica Neue"
                , sansSerif.value
                ]
            ]
        , class WindowWrapper
            [ position absolute
            , width (pct 100)
            , height (pct 100)
            ]
        , class CentredPage
            [ width (px 1200)
            , height (pct 100)
            , margin auto
            , boxSizing borderBox
            , paddingTop (Css.rem 2)
            , paddingBottom (Css.rem 2)
            ]
        , class GameColumn
            [ displayFlex
            , flexDirection column
            , float left
            , justifyContent center
            , width gameColumnWidth
            , height (pct 100)
            ]
        , class Game
            [ displayFlex
            , justifyContent center
            ]
        , class SidePanButton
            [ displayFlex
            , flexDirection column
            , justifyContent center
            ]
        , class ControlPanelColumn
            [ displayFlex
            , flexDirection column
            , justifyContent center
            , height (pct 100)
            , marginLeft gameColumnWidth
            ]
        , class ControlPanelSection
            [ displayFlex
            , flexDirection column
            , position relative
            , justifyContent center
            , height (pct 50)
            ]
        , class ControlPanelInside
            [ displayFlex
            , flexDirection column
            ]
        , class ZoomControls
            [ position absolute
            , bottom (pct 10)
            ]
        , class ZoomButton
            [ display block
            ]
        ]


styles =
    Css.asPairs >> Html.Attributes.style


controlPanelInside config =
    styles
        [ height (px (toFloat config.svgSize)) ]


gameColumnWidth =
    pct (100 * 4 / 7)
