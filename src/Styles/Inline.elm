module Styles.Inline exposing (..)

import Css exposing (..)
import Html.Attributes


styles =
    Css.asPairs >> Html.Attributes.style


controlPanelInside config =
    styles
        [ height (px (toFloat config.svgSize)) ]
