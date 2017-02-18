module Messages exposing (..)

import Time exposing (Time)
import Coordinates exposing (Coordinates)


type Msg
    = ToggleRunning
    | Tick Time
    | MouseClick Coordinates
    | ZoomOut
    | ZoomIn
    | Pan Direction
    | DecreaseSpeed
    | IncreaseSpeed
    | NextState


type Direction
    = Up
    | Down
    | Left
    | Right
