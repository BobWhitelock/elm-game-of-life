module TickPeriod
    exposing
        ( increaseSpeedIfPossible
        , decreaseSpeedIfPossible
        , isMinimumSpeed
        , isMaximumSpeed
        , frequency
        )

import Time exposing (Time)


increaseSpeedIfPossible : Time -> Time
increaseSpeedIfPossible tickPeriod =
    if isMaximumSpeed tickPeriod then
        tickPeriod
    else
        increaseSpeed tickPeriod


decreaseSpeedIfPossible : Time -> Time
decreaseSpeedIfPossible tickPeriod =
    if isMinimumSpeed tickPeriod then
        tickPeriod
    else
        decreaseSpeed tickPeriod


isMinimumSpeed : Time -> Bool
isMinimumSpeed tickPeriod =
    decreaseSpeed tickPeriod > maximumTickPeriod


isMaximumSpeed : Time -> Bool
isMaximumSpeed tickPeriod =
    increaseSpeed tickPeriod < minimumTickPeriod


frequency : Time -> Float
frequency tickPeriod =
    (1 * Time.second) / tickPeriod


increaseSpeed : Time -> Time
increaseSpeed tickPeriod =
    changeSpeed tickPeriod 0.5


decreaseSpeed : Time -> Time
decreaseSpeed tickPeriod =
    changeSpeed tickPeriod 2


changeSpeed : Time -> Float -> Time
changeSpeed tickPeriod factor =
    tickPeriod * factor


maximumTickPeriod : Time
maximumTickPeriod =
    1300


minimumTickPeriod : Time
minimumTickPeriod =
    20
