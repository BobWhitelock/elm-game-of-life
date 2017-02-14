
var Elm = require('./Main.elm')

// In development require Stylesheets module directly using
// `elm-css-webpack-loader`, in order to easily have this rebuild while
// developing; in production this wasn't working for some reason I can't figure
// out, so compile module to CSS separately using `elm-css` and then require
// the resulting file.
if (process.env.NODE_ENV === 'development') {
  require('./Stylesheets.elm')
} else {
  require('../dist/css/index.css')
}

var root = document.getElementById('root')

var iconsDir = './icons/feather-v1.1/'

var iconNames = [
  'arrow-down',
  'arrow-left',
  'arrow-right',
  'arrow-up',
  'fast-forward',
  'minus',
  'pause',
  'play',
  'plus',
  'rewind',
  'skip-back',
  'skip-forward',
]

var icons = {}
iconNames.forEach(function(icon) {
  icons[icon] = require(iconsDir + icon + '.svg')
})

Elm.Main.embed(root, icons)
