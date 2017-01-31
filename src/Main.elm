module Main exposing (..)

import Json.Encode exposing (Value)
import Model exposing (Model, init)
import Update exposing (update)
import View exposing (view)
import Subscriptions exposing (subscriptions)
import Messages exposing (Msg)
import Html exposing (programWithFlags)


main : Program Value Model Msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
