module Model exposing (..)

import Set exposing (Set)
import Messages exposing (Msg(..))
import Cell exposing (Cell)
import Coordinates exposing (Coordinates)
import ViewConfig exposing (ViewConfig)


type alias Model =
    { livingCells : Set Cell
    , running : Bool
    , lastMouseClick : Coordinates
    , viewConfig : ViewConfig
    }


init : String -> ( Model, Cmd Msg )
init _ =
    ( { livingCells =
            Set.fromList
                [ ( 1, 0 )
                , ( 2, 1 )
                , ( 0, 2 )
                , ( 1, 2 )
                , ( 2, 2 )
                ]
      , running = False
      , lastMouseClick = ( 0, 0 )
      , viewConfig = ViewConfig.defaultConfig
      }
    , Cmd.none
    )
