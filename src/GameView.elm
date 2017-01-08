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
    let
        svgSize =
            toString config.svgSize
    in
        svg
            [ width svgSize
            , height svgSize
            , viewBox (viewBoxSizeString model)
            , on "click" (Json.map MouseClick (relativeCoordinates model.zoomLevel))
            ]
            (List.concat
                [ gridLines model
                , gridCells model
                ]
            )


relativeCoordinates : Float -> Json.Decoder Coordinates
relativeCoordinates zoomLevel =
    -- Decode the Coordinates of the current mouse position relative to the origin.
    let
        offsetX =
            Json.field "offsetX" Json.int

        offsetY =
            Json.field "offsetY" Json.int

        coordinatesFromOffsetPosition =
            \x ->
                \y ->
                    ( floor ((toFloat x / zoomLevel) - toFloat config.borderSize)
                    , floor ((toFloat y / zoomLevel) - toFloat config.borderSize)
                    )
    in
        Json.map2 coordinatesFromOffsetPosition offsetX offsetY


farBorderPosition : Float -> Int
farBorderPosition zoomLevel =
    ViewConfig.farBorderPosition config zoomLevel


lineWidth : String
lineWidth =
    "0.5"


viewBoxSizeString : Model -> String
viewBoxSizeString model =
    let
        sizeString =
            toString (ViewConfig.viewBoxSize config model.zoomLevel)
    in
        "0 0 " ++ sizeString ++ " " ++ sizeString


gridLines : Model -> List (Svg Msg)
gridLines model =
    let
        lineRange =
            List.range 0 (ViewConfig.visibleCells config model.zoomLevel)

        linesUsing =
            \lineFunction ->
                List.map (\n -> lineFunction ((config.cellSize * n) + config.borderSize)) lineRange
    in
        List.concat
            [ linesUsing (verticalLineAt model.zoomLevel)
            , linesUsing (horizontalLineAt model.zoomLevel)
            ]


verticalLineAt : Float -> Int -> Svg Msg
verticalLineAt zoomLevel xCoord =
    lineBetween ( xCoord, config.borderSize ) ( xCoord, farBorderPosition zoomLevel )


horizontalLineAt : Float -> Int -> Svg Msg
horizontalLineAt zoomLevel yCoord =
    lineBetween ( config.borderSize, yCoord ) ( farBorderPosition zoomLevel, yCoord )


lineBetween : Coordinates -> Coordinates -> Svg Msg
lineBetween ( xStart, yStart ) ( xEnd, yEnd ) =
    line
        [ x1 (toString xStart)
        , y1 (toString yStart)
        , x2 (toString xEnd)
        , y2 (toString yEnd)
        , strokeWidth lineWidth
        , stroke "black"
        ]
        []


gridCells : Model -> List (Svg Msg)
gridCells model =
    let
        topLeftCell =
            ( 0, 0 )

        bottomRightCellCoordinate =
            (ViewConfig.visibleCells config model.zoomLevel) - (1)

        bottomRightCell =
            ( bottomRightCellCoordinate, bottomRightCellCoordinate )

        isVisible =
            Cell.isVisible topLeftCell bottomRightCell

        drawCellRect =
            \( x, y ) ->
                cellRectAt ( config.borderSize + (config.cellSize * x), config.borderSize + (config.cellSize * y) )
    in
        Set.filter isVisible model.livingCells
            |> Set.toList
            |> List.map drawCellRect


cellRectAt : Coordinates -> Svg Msg
cellRectAt ( rectX, rectY ) =
    rect
        [ x (toString rectX)
        , y (toString rectY)
        , width (toString config.cellSize)
        , height (toString config.cellSize)
        , strokeWidth lineWidth
        , stroke "black"
        , fill "darkgrey"
        ]
        []
