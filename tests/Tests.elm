module Tests exposing (..)

import Test exposing (..)
import CellTests
import CoordinatesTests
import ZoomLevelTests


-- TODO: Need to duplicate main app dependencies for `tests` dir?


all : Test
all =
    describe "App"
        [ CellTests.all
        , CoordinatesTests.all
        , ZoomLevelTests.all
        ]
