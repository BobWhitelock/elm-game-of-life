module Subscriptions exposing (subscriptions)

import Time exposing (Time, millisecond)
import Messages exposing (..)
import Model exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.running then
        Time.every model.tickPeriod Tick
    else
        Sub.none
