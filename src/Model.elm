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
import WorldState exposing (WorldState)


type alias Model =
    { history : History
    , running : Bool
    , tickPeriod : Time
    , lastMouseClick : Coordinates
    , viewConfig : ViewConfig
    , icons : Icons
    }


type alias History =
    -- Non-empty List of all previous WorldStates; the head contains the
    -- current state, which may be modified by the user.
    Nonempty WorldState



-- TODO: decode and store icons in more robust way than a dict, and report
-- errors when one is not present.


type alias Icons =
    Dict String String


init : Json.Value -> ( Model, Cmd Msg )
init iconsJson =
    ( { history = List.Nonempty.fromElement initialWorldState
      , running = False
      , tickPeriod = 200 * Time.millisecond
      , lastMouseClick = ( 0, 0 )
      , viewConfig = ViewConfig.defaultConfig
      , icons = decodeIcons iconsJson
      }
    , Cmd.none
    )


initialWorldState : WorldState
initialWorldState =
    Set.fromList
        [ ( 1, 0 )
        , ( 2, 1 )
        , ( 0, 2 )
        , ( 1, 2 )
        , ( 2, 2 )
        ]
        |> WorldState.fromExistingCells


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
