module Tests exposing (..)

import Test exposing (..)
import CellTests
import ZoomLevelTests


-- TODO: Need to duplicate main app dependencies for `tests` dir?


all : Test
all =
    describe "App"
        [ CellTests.all
        , ZoomLevelTests.all
        ]
