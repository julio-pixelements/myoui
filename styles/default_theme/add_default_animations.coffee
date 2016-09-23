
css_utils = require '../css_utils.coffee'

if process.browser # browser code
    css_animations = require 'raw!./css/animations.css'

else # electron code
    fs = require 'fs'
    dirname =  __dirname.replace(/\\/g, '/')
    css_animations = fs.readFileSync dirname + '/css/animations.css', 'utf8'

css_utils.add_css css_animations
