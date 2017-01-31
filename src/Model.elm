module Model exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)
import Time exposing (Time)
import Json.Decode as Json
import Messages exposing (Msg(..))
import Cell exposing (Cell)
import Coordinates exposing (Coordinates)
import ViewConfig exposing (ViewConfig)


type alias Model =
    { livingCells : Set Cell
    , running : Bool
    , ticks : Int
    , tickPeriod : Time
    , lastMouseClick : Coordinates
    , viewConfig : ViewConfig
    , icons : Icons
    }



-- TODO: decode and store icons in more robust way than a dict, and report
-- errors when one is not present.


type alias Icons =
    Dict String String


init : Json.Value -> ( Model, Cmd Msg )
init iconsJson =
    ( { livingCells =
            Set.fromList
                [ ( 1, 0 )
                , ( 2, 1 )
                , ( 0, 2 )
                , ( 1, 2 )
                , ( 2, 2 )
                ]
      , running = False
      , ticks = 0
      , tickPeriod = 200 * Time.millisecond
      , lastMouseClick = ( 0, 0 )
      , viewConfig = ViewConfig.defaultConfig
      , icons = decodeIcons iconsJson
      }
    , Cmd.none
    )


decodeIcons : Json.Value -> Icons
decodeIcons json =
    let
        unpackedResult =
            Result.withDefault [] decodeResult

        decodeResult =
            Json.decodeValue decoder json

        decoder =
            Json.keyValuePairs Json.string
    in
        Dict.fromList unpackedResult
