module Tests exposing (..)

import Test exposing (..)
import CellTests
import CoordinatesTests


-- TODO: Need to duplicate main app dependencies for `tests` dir?


all : Test
all =
    describe "App"
        [ CellTests.all
        , CoordinatesTests.all
        ]
