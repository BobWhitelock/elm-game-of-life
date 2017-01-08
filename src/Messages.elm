module Messages exposing (..)

import Time exposing (Time)
import Coordinates exposing (Coordinates)


type Msg
    = ToggleRunning
    | Tick Time
    | MouseClick Coordinates
    | ZoomOut
    | ZoomIn
