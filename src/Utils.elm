module Utils exposing (..)

import Set exposing (Set)


toggleIn : comparable -> Set comparable -> Set comparable
toggleIn x xs =
    if Set.member x xs then
        Set.remove x xs
    else
        Set.insert x xs
