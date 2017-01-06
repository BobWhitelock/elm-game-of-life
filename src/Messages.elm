module Messages exposing (..)

import Time exposing (Time)
import Cell exposing (Cell)
import Coordinates exposing (Coordinates)


type Msg
    = ToggleRunning
    | Tick Time
    | MouseClick Coordinates
