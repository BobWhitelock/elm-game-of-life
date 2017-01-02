module App exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


type alias Model =
    { livingCells : List Cell
    }


type alias Cell =
    ( Int, Int )


init : String -> ( Model, Cmd Msg )
init _ =
    ( { livingCells = [ ( 1, 1 ), ( 1, 3 ) ] }, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    svg
        [ width "1000"
        , height "1000"
        , viewBox "0 0 500 500"
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


gridCells : List Cell -> List (Svg Msg)
gridCells cells =
    let
        drawCellRect =
            \( x, y ) ->
                rect ( 10 + (10 * x), 10 + (10 * y) )
    in
        List.map drawCellRect cells


rect : ( Int, Int ) -> Svg Msg
rect ( rectX, rectY ) =
    Svg.rect
        [ x (toString rectX)
        , y (toString rectY)
        , width "10"
        , height "10"
        ]
        []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
