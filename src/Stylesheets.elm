port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Styles


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    -- Note: file name is a placeholder here as styles will be loaded using
    -- elm-css-webpack-loader (rather than compiled to a CSS file and loaded
    -- via a style tag).
    Css.File.toFileStructure
        [ ( "placeholder", Css.File.compile [ Styles.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
