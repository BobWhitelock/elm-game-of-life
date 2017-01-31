
require('./main.css')
var Elm = require('./Main.elm')

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
