module GameView exposing (gameView)

import Html exposing (Html)
import Set exposing (Set)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Messages exposing (Msg)
import Model exposing (Model)
import Cell exposing (Cell)


gameView : Model -> Html Msg
gameView model =
    svg
        [ width "500"
        , height "500"
        , viewBox "0 0 200 200"
        ]
        (List.concat
            [ gridLines
            , gridCells model.livingCells
            ]
        )


gridLines : List (Svg Msg)
gridLines =
    let
        lineRange =
            List.range 1 11

        linesUsing =
            \lineFunction ->
                List.map (\n -> lineFunction (10 * n)) lineRange
    in
        List.concat
            [ linesUsing verticalLineAt
            , linesUsing horizontalLineAt
            ]



-- TODO: get rid of implicit hard-coding of cell/border size numbers.


verticalLineAt : Int -> Svg Msg
verticalLineAt xCoord =
    line ( xCoord, 10 ) ( xCoord, 110 )


horizontalLineAt : Int -> Svg Msg
horizontalLineAt yCoord =
    line ( 10, yCoord ) ( 110, yCoord )


line : ( Int, Int ) -> ( Int, Int ) -> Svg Msg
line ( xStart, yStart ) ( xEnd, yEnd ) =
    Svg.line
        [ x1 (toString xStart)
        , y1 (toString yStart)
        , x2 (toString xEnd)
        , y2 (toString yEnd)
        , strokeWidth "1"
        , stroke "black"
        ]
        []



-- TODO: Don't draw outside of grid area.


gridCells : Set Cell -> List (Svg Msg)
gridCells cells =
    let
        drawCellRect =
            \( x, y ) ->
                rect ( 10 + (10 * x), 10 + (10 * y) )
    in
        -- TODO: Need to convert to list here?
        Set.toList cells
            |> List.map drawCellRect


rect : ( Int, Int ) -> Svg Msg
rect ( rectX, rectY ) =
    Svg.rect
        [ x (toString rectX)
        , y (toString rectY)
        , width "10"
        , height "10"
        ]
        []
