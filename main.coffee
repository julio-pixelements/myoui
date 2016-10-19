{ React, ReactDOM, Radium, Component, mixins } = require './common.coffee'

{Theme} = require './styles/default_theme/default_theme.coffee'

# utils
react_utils = {Radium, React, ReactDOM, Component}
css_utils = require './styles/css_utils.coffee'

elements = [
    require('./elements/button.coffee').Button
    require('./elements/switch.coffee').Switch
    require('./elements/slider.coffee').Slider
    require('./elements/vector.coffee').Vector
    require('./elements/text_input.coffee').TextInput
    require('./elements/selector.coffee').Selector
    require('./elements/splitter.coffee').Splitter
    require('./elements/popup_menu.coffee').PopupMenuManager
]

class MyoUI
    constructor: (@theme=new Theme)->

        # classes customization with common context.
        for cls in elements
            new_class = class extends cls
            new_class::context = @
            @[cls.name] = new_class

        # TODO: find a better way to do this
        required_css = '''
        .myoui * {
            box-sizing: border-box;
            margin: 0;
          }
        '''
        # TODO: do not use reactSelect
        if process.browser # browser code
            reactSelect = require 'raw!./styles/default_theme/css/react-select.css'
        else # electron code
            fs = require 'fs'
            dirname =  __dirname.replace(/\\/g, '/')
            reactSelect = fs.readFileSync dirname + '/styles/default_theme/css/react-select.css', 'utf8'
        # Adding css to the document
        css_utils.add_css required_css + reactSelect

module.exports = {MyoUI, mixins, Theme, css_utils, react_utils}
