module App exposing (..)

import Html exposing (Html)
import Set exposing (Set)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, millisecond)


type alias Model =
    { livingCells : Set Cell
    }


type alias Cell =
    ( Int, Int )


init : String -> ( Model, Cmd Msg )
init _ =
    ( { livingCells =
            Set.fromList
                [ ( 1, 0 )
                , ( 2, 1 )
                , ( 0, 2 )
                , ( 1, 2 )
                , ( 2, 2 )
                ]
      }
    , Cmd.none
    )


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model
                | livingCells = nextLivingCells model.livingCells
              }
            , Cmd.none
            )


nextLivingCells : Set Cell -> Set Cell
nextLivingCells livingCells =
    let
        cellIsAlive =
            isAlive livingCells

        willBeAlive =
            \cell ->
                let
                    currentCellIsAlive =
                        cellIsAlive cell

                    numberLivingNeighbours =
                        (livingNeighbours livingCells cell) |> Set.size

                    hasLivingNeighboursIn =
                        \list ->
                            List.member numberLivingNeighbours list

                    staysAlive =
                        currentCellIsAlive && hasLivingNeighboursIn [ 2, 3 ]

                    comesAlive =
                        not currentCellIsAlive && hasLivingNeighboursIn [ 3 ]
                in
                    staysAlive || comesAlive
    in
        Set.filter willBeAlive (activeCells livingCells)


neighbours : Cell -> Set Cell
neighbours cell =
    let
        deltas =
            [ ( -1, -1 )
            , ( -1, 0 )
            , ( -1, 1 )
            , ( 0, -1 )
            , ( 0, 1 )
            , ( 1, -1 )
            , ( 1, 0 )
            , ( 1, 1 )
            ]
    in
        List.map (add cell) deltas
            |> Set.fromList


livingNeighbours : Set Cell -> Cell -> Set Cell
livingNeighbours livingCells cell =
    Set.filter (isAlive livingCells) (neighbours cell)


isAlive : Set Cell -> Cell -> Bool
isAlive livingCells cell =
    Set.member cell livingCells


activeCells : Set Cell -> Set Cell
activeCells livingCells =
    let
        collectNeighbours =
            \cell ->
                \collected ->
                    Set.union collected (neighbours cell)

        allNeighbours =
            Set.foldl collectNeighbours Set.empty livingCells
    in
        Set.union allNeighbours livingCells


add : Cell -> Cell -> Cell
add ( x1, y1 ) ( x2, y2 ) =
    ( x1 + x2, y1 + y2 )


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (300 * millisecond) Tick
