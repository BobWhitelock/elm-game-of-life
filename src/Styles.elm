module Styles exposing (..)

import Css exposing (..)
import Html.Attributes


styles =
    Css.asPairs >> Html.Attributes.style


windowWrapper =
    styles
        [ position absolute
        , width (pct 100)
        , height (pct 100)
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


centredPage =
    styles
        [ width (px 1200)
        , height (pct 100)
        , margin auto
        , boxSizing borderBox
        , paddingTop (Css.rem 2)
        , paddingBottom (Css.rem 2)
        ]


gameColumn =
    styles
        [ displayFlex
        , flexDirection column
        , float left
        , property "justify-content" "center"
        , width (pct gameColumnWidth)
        , height (pct 100)
        ]


game =
    styles
        [ displayFlex
        , property "justify-content" "center"
        ]


sidePanButton =
    styles
        [ displayFlex
        , flexDirection column
        , property "justify-content" "center"
        ]


controlPanelColumn =
    styles
        [ displayFlex
        , flexDirection column
        , float right
        , property "justify-content" "center"
        , width (pct controlPanelWidth)
        , height (pct 100)
        ]


controlPanelInside config =
    styles
        [ displayFlex
        , flexDirection column
        , height (px (toFloat config.svgSize))
        ]


controlPanelSection =
    styles
        [ displayFlex
        , flexDirection column
        , property "justify-content" "center"
        , height (pct 50)
        ]


gameColumnWidth =
    100 - controlPanelWidth


controlPanelWidth =
    100 / 3
