module Utils exposing (..)

import Set exposing (Set)


toggleIn : Set comparable -> comparable -> Set comparable
toggleIn xs x =
    if Set.member x xs then
        Set.remove x xs
    else
        Set.insert x xs
