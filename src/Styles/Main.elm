port module Stylesheets exposing (..)

-- Note: This module has to be called `Stylesheets` as `elm-css` expects it to
-- be called that unless a `--module` option is passed, and
-- `elm-css-webpack-loader` doesn't expose that capability.

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Styles.Stylesheet as Stylesheet


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "index.css", Css.File.compile [ Stylesheet.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
