module ZoomLevel
    exposing
        ( ZoomLevel
        , initial
        , scale
        , zoomIn
        , zoomOut
        , isMaximum
        , isMinimum
        )


type
    ZoomLevel
    -- Don't expose this so clients cannot create ZoomLevels themselves, they
    -- can only use the exposed methods.
    = ZoomLevel Int


initial : ZoomLevel
initial =
    ZoomLevel 0


zoomIn : ZoomLevel -> ZoomLevel
zoomIn zoomLevel =
    if isMaximum zoomLevel then
        zoomLevel
    else
        withExponent (exponent zoomLevel + 1)


zoomOut : ZoomLevel -> ZoomLevel
zoomOut zoomLevel =
    if isMinimum zoomLevel then
        zoomLevel
    else
        withExponent (exponent zoomLevel - 1)


scale : ZoomLevel -> Float
scale zoomLevel =
    toFloat (2 ^ exponent zoomLevel)


isMaximum : ZoomLevel -> Bool
isMaximum zoomLevel =
    exponent zoomLevel == maximumExponent


isMinimum : ZoomLevel -> Bool
isMinimum zoomLevel =
    exponent zoomLevel == minimumExponent


withExponent : Int -> ZoomLevel
withExponent exponent =
    ZoomLevel exponent


exponent : ZoomLevel -> Int
exponent zoomLevel =
    case zoomLevel of
        ZoomLevel exponent_ ->
            exponent_


maximumExponent : Int
maximumExponent =
    1


minimumExponent : Int
minimumExponent =
    -3
