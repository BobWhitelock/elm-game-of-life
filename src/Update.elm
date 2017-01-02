module Update exposing (update)

import Set exposing (Set)
import Model exposing (Model)
import Cell exposing (..)
import Messages exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleRunning ->
            ( { model
                | running = not model.running
              }
            , Cmd.none
            )

        Tick _ ->
            ( { model
                | livingCells = nextLivingCells model.livingCells
              }
            , Cmd.none
            )
