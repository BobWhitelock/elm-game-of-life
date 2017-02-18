module GameView exposing (gameView)

import Html exposing (Html)
import Json.Decode as Json
import Set exposing (Set)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (on)
import List.Nonempty
import Messages exposing (Msg(..))
import Model exposing (Model)
import Cell exposing (Cell)
import Coordinates exposing (Coordinates)
import ViewConfig exposing (ViewConfig)
import ZoomLevel


gameView : Model -> Html Msg
gameView model =
    let
        config =
            model.viewConfig

        svgSize =
            toString config.svgSize
    in
        svg
            [ width svgSize
            , height svgSize
            , viewBox (viewBoxSizeString model)
            , on "click" (Json.map MouseClick (decodeCoordinates config))
            ]
            (List.concat
                [ gridLines model
                , gridCells model
                ]
            )


decodeCoordinates : ViewConfig -> Json.Decoder Coordinates
decodeCoordinates config =
    let
        x =
            Json.field "offsetX" Json.float

        y =
            Json.field "offsetY" Json.float
    in
        Json.map2 (coordinatesFromMouseClick config) x y


coordinatesFromMouseClick : ViewConfig -> Float -> Float -> Coordinates
coordinatesFromMouseClick config x y =
    -- Decode Coordinates from a mouse click relative to the SVG origin, given
    -- this view configuration.
    let
        scale =
            ZoomLevel.scale config.zoomLevel

        scaledX =
            x / scale

        scaledY =
            y / scale

        border =
            toFloat config.borderSize
    in
        ( floor (scaledX - border)
        , floor (scaledY - border)
        )


farBorderPosition : ViewConfig -> Int
farBorderPosition config =
    ViewConfig.farBorderPosition config


lineWidth : String
lineWidth =
    "0.5"


viewBoxSizeString : Model -> String
viewBoxSizeString model =
    let
        sizeString =
            toString (ViewConfig.viewBoxSize model.viewConfig)
    in
        "0 0 " ++ sizeString ++ " " ++ sizeString


gridLines : Model -> List (Svg Msg)
gridLines model =
    let
        config =
            model.viewConfig

        lineRange =
            List.range 0 (ViewConfig.visibleCells config)

        linesUsing =
            \lineFunction ->
                List.map (\n -> lineFunction ((config.cellSize * n) + config.borderSize)) lineRange
    in
        List.concat
            [ linesUsing (verticalLineAt model.viewConfig)
            , linesUsing (horizontalLineAt model.viewConfig)
            ]


verticalLineAt : ViewConfig -> Int -> Svg Msg
verticalLineAt config xCoord =
    lineBetween ( xCoord, config.borderSize ) ( xCoord, farBorderPosition config )


horizontalLineAt : ViewConfig -> Int -> Svg Msg
horizontalLineAt config yCoord =
    lineBetween ( config.borderSize, yCoord ) ( farBorderPosition config, yCoord )


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
            config.topLeft

        ( topLeftX, topLeftY ) =
            topLeftCell

        cellOffset =
            (ViewConfig.visibleCells config) - 1

        bottomRightCell =
            ( topLeftX + cellOffset, topLeftY + cellOffset )

        isVisible =
            Cell.isVisible topLeftCell bottomRightCell

        config =
            model.viewConfig

        drawCellRect =
            \cell ->
                cellRectAt config (Coordinates.fromCell config cell)
    in
        List.Nonempty.head model.cellHistory
            |> Set.filter isVisible
            |> Set.toList
            |> List.map drawCellRect


cellRectAt : ViewConfig -> Coordinates -> Svg Msg
cellRectAt config ( rectX, rectY ) =
    rect
        [ x (toString (rectX + config.borderSize))
        , y (toString (rectY + config.borderSize))
        , width (toString config.cellSize)
        , height (toString config.cellSize)
        , strokeWidth lineWidth
        , stroke "black"
        , fill "darkgrey"
        ]
        []
