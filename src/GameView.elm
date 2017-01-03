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
        [ width worldViewSizeString
        , height worldViewSizeString
        , viewBox viewBoxSizeString
        ]
        (List.concat
            [ gridLines
            , gridCells model.livingCells
            ]
        )


borderSize : Int
borderSize =
    5


cellSize : Int
cellSize =
    10


numberVisibleCells : Int
numberVisibleCells =
    24


farBorderPosition : Int
farBorderPosition =
    (cellSize * numberVisibleCells) + borderSize


scale : Int
scale =
    2


viewBoxSize : Int
viewBoxSize =
    (numberVisibleCells * cellSize) + (borderSize * 2)


viewBoxSizeString : String
viewBoxSizeString =
    let
        sizeString =
            toString viewBoxSize
    in
        "0 0 " ++ sizeString ++ " " ++ sizeString


worldViewSizeString : String
worldViewSizeString =
    toString (scale * viewBoxSize)


gridLines : List (Svg Msg)
gridLines =
    let
        lineRange =
            List.range 0 numberVisibleCells

        linesUsing =
            \lineFunction ->
                List.map (\n -> lineFunction ((cellSize * n) + borderSize)) lineRange
    in
        List.concat
            [ linesUsing verticalLineAt
            , linesUsing horizontalLineAt
            ]


verticalLineAt : Int -> Svg Msg
verticalLineAt xCoord =
    line ( xCoord, borderSize ) ( xCoord, farBorderPosition )


horizontalLineAt : Int -> Svg Msg
horizontalLineAt yCoord =
    line ( borderSize, yCoord ) ( farBorderPosition, yCoord )


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
                rect ( borderSize + (cellSize * x), borderSize + (cellSize * y) )
    in
        -- TODO: Need to convert to list here?
        Set.toList cells
            |> List.map drawCellRect


rect : ( Int, Int ) -> Svg Msg
rect ( rectX, rectY ) =
    Svg.rect
        [ x (toString rectX)
        , y (toString rectY)
        , width (toString cellSize)
        , height (toString cellSize)
        , stroke "black"
        , fill "darkgrey"
        ]
        []
