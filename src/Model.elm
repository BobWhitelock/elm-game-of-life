module Model exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)
import Time exposing (Time)
import Json.Decode as Json
import List.Nonempty exposing (Nonempty)
import Messages exposing (Msg(..))
import Cell exposing (Cell)
import Coordinates exposing (Coordinates)
import ViewConfig exposing (ViewConfig)


type alias Model =
    { cellHistory : CellHistory
    , running : Bool
    , tickPeriod : Time
    , lastMouseClick : Coordinates
    , viewConfig : ViewConfig
    , icons : Icons
    }


type alias CellHistory =
    -- Non-empty List of all previous sets of living Cells; the head contains
    -- the currently living Cells.
    Nonempty (Set Cell)



-- TODO: decode and store icons in more robust way than a dict, and report
-- errors when one is not present.


type alias Icons =
    Dict String String


init : Json.Value -> ( Model, Cmd Msg )
init iconsJson =
    ( { cellHistory = initialCellHistory
      , running = False
      , tickPeriod = 200 * Time.millisecond
      , lastMouseClick = ( 0, 0 )
      , viewConfig = ViewConfig.defaultConfig
      , icons = decodeIcons iconsJson
      }
    , Cmd.none
    )


initialCellHistory =
    List.Nonempty.fromElement
        (Set.fromList
            [ ( 1, 0 )
            , ( 2, 1 )
            , ( 0, 2 )
            , ( 1, 2 )
            , ( 2, 2 )
            ]
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
