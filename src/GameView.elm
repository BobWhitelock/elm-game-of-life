module GameView exposing (gameView)

import Html exposing (Html)
import Json.Decode as Json
import Set exposing (Set)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (on)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Cell exposing (Cell)
import Coordinates exposing (Coordinates)
import ViewConfig exposing (config)


gameView : Model -> Html Msg
gameView model =
    svg
        [ width worldViewSizeString
        , height worldViewSizeString
        , viewBox viewBoxSizeString
        , on "click" (Json.map MouseClick relativeCoordinates)
        ]
        (List.concat
            [ gridLines
            , gridCells model.livingCells
            ]
        )


relativeCoordinates : Json.Decoder Coordinates
relativeCoordinates =
    -- Decode the Coordinates of the current mouse position relative to the origin.
    let
        offsetX =
            Json.field "offsetX" Json.int

        offsetY =
            Json.field "offsetY" Json.int

        coordinatesFromOffsetPosition =
            \x ->
                \y ->
                    ( (x // scale) - config.borderSize
                    , (y // scale) - config.borderSize
                    )
    in
        Json.map2 coordinatesFromOffsetPosition offsetX offsetY


farBorderPosition : Int
farBorderPosition =
    ViewConfig.farBorderPosition config


scale : Int
scale =
    2


viewBoxSize : Int
viewBoxSize =
    (config.visibleCells * config.cellSize) + (config.borderSize * 2)


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
            List.range 0 config.visibleCells

        linesUsing =
            \lineFunction ->
                List.map (\n -> lineFunction ((config.cellSize * n) + config.borderSize)) lineRange
    in
        List.concat
            [ linesUsing verticalLineAt
            , linesUsing horizontalLineAt
            ]


verticalLineAt : Int -> Svg Msg
verticalLineAt xCoord =
    lineBetween ( xCoord, config.borderSize ) ( xCoord, farBorderPosition )


horizontalLineAt : Int -> Svg Msg
horizontalLineAt yCoord =
    lineBetween ( config.borderSize, yCoord ) ( farBorderPosition, yCoord )


lineBetween : Coordinates -> Coordinates -> Svg Msg
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


gridCells : Set Cell -> List (Svg Msg)
gridCells cells =
    let
        topLeftCell =
            ( 0, 0 )

        bottomRightCellCoordinate =
            config.visibleCells - (1)

        bottomRightCell =
            ( bottomRightCellCoordinate, bottomRightCellCoordinate )

        isVisible =
            Cell.isVisible topLeftCell bottomRightCell

        drawCellRect =
            \( x, y ) ->
                cellRectAt ( config.borderSize + (config.cellSize * x), config.borderSize + (config.cellSize * y) )
    in
        Set.filter isVisible cells
            |> Set.toList
            |> List.map drawCellRect


cellRectAt : Coordinates -> Svg Msg
cellRectAt ( rectX, rectY ) =
    rect
        [ x (toString rectX)
        , y (toString rectY)
        , width (toString config.cellSize)
        , height (toString config.cellSize)
        , stroke "black"
        , fill "darkgrey"
        ]
        []
