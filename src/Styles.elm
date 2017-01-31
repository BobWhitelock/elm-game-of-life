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
        , justifyContent center
        , width gameColumnWidth
        , height (pct 100)
        ]


game =
    styles
        [ displayFlex
        , justifyContent center
        ]


sidePanButton =
    styles
        [ displayFlex
        , flexDirection column
        , justifyContent center
        ]


controlPanelColumn =
    styles
        [ displayFlex
        , flexDirection column
        , justifyContent center
        , height (pct 100)
        , marginLeft gameColumnWidth
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
        , position relative
        , justifyContent center
        , height (pct 50)
        ]


zoomControls =
    styles
        [ position absolute
        , bottom (pct 10)
        ]


zoomButton =
    styles
        [ display block
        ]


gameColumnWidth =
    pct (100 * 4 / 7)
