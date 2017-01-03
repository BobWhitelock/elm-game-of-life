module GameView exposing (gameView)

import Html exposing (Html)
import Set exposing (Set)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Messages exposing (Msg)
import Model exposing (Model)
import Cell exposing (Cell)


type alias Coordinate =
    ( Int, Int )


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
    lineBetween ( xCoord, borderSize ) ( xCoord, farBorderPosition )


horizontalLineAt : Int -> Svg Msg
horizontalLineAt yCoord =
    lineBetween ( borderSize, yCoord ) ( farBorderPosition, yCoord )


lineBetween : Coordinate -> Coordinate -> Svg Msg
lineBetween ( xStart, yStart ) ( xEnd, yEnd ) =
    line
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
                cellRectAt ( borderSize + (cellSize * x), borderSize + (cellSize * y) )
    in
        -- TODO: Need to convert to list here?
        Set.toList cells
            |> List.map drawCellRect


cellRectAt : Coordinate -> Svg Msg
cellRectAt ( rectX, rectY ) =
    rect
        [ x (toString rectX)
        , y (toString rectY)
        , width (toString cellSize)
        , height (toString cellSize)
        , stroke "black"
        , fill "darkgrey"
        ]
        []
