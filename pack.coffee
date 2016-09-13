{ React, ReactDOM, Radium, Component, mixins } = require './common.coffee'

# utils
react_utils = {Radium, React, ReactDOM, Component}
theme_utils = require './styles/theme.coffee'
css_utils = require './styles/css_utils.coffee'

# myoui elements classes
{Button} = require './elements/button.coffee'
{Switch} = require './elements/switch.coffee'
{Slider} = require './elements/slider.coffee'
{Vector} = require './elements/vector.coffee'
{TextInput} = require './elements/text_input.coffee'
{Selector} = require './elements/selector.coffee'
{Splitter} = require './elements/splitter.coffee'
{PopupMenuManager} = require './elements/popup_menu.coffee'
myoui_classes = [Button, Switch, Slider, Vector, TextInput, Selector, Splitter, PopupMenuManager]

class MyoUI
    constructor: (settings)->
        if settings
            {theme, css_animations, font_faces, extra_css} = settings
        theme = @theme = new theme_utils.Theme theme

        # classes customization with common context.
        for cls in myoui_classes
            new_class = class extends cls
            new_class::context = @
            @[cls.name] = new_class

        # TODO: use css as modules.

        # common base style
        base_css = '''
        .myoui * {
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            margin: 0;
          }
        '''
        # generating css and ensuring copying of the woff files using webpack.
        {font_face, add_css} = css_utils
        extra_css = extra_css or ''
        font_faces = font_faces or [
                # font_face 'roboto', 'Roboto thin', 100, 'normal', require './fonts/roboto/Roboto-Thin.woff'
                # font_face 'roboto', 'Roboto thin Italic', 100, 'normal', require './fonts/roboto/Roboto-ThinItalic.woff'
                font_face 'Roboto', 'Roboto Light', 300, 'normal', require './fonts/roboto/Roboto-Light.woff'
                # font_face 'Roboto', 'Roboto Light Italic', 300, 'italic', require './fonts/roboto/Roboto-LightItalic.woff'
                font_face 'Roboto', 'Roboto Regular', 400, 'normal', require './fonts/roboto/Roboto-Regular.woff'
                # font_face 'Roboto', 'Roboto Italic', 400, 'italic', require './fonts/roboto/Roboto-Italic.woff'
                # font_face 'Roboto', 'Roboto Bold', 700, 'normal', require './fonts/roboto/Roboto-Bold.woff'
                # font_face 'Roboto', 'Roboto Bold Italic', 700, 'italic', require './fonts/roboto/Roboto-BoldItalic.woff'
                # font_face 'Roboto', 'Roboto Black', 900, 'normal', require './fonts/roboto/Roboto-Black.woff'
                # font_face 'Roboto', 'Roboto Black Italic', 900, 'italic', require './fonts/roboto/Roboto-BlackItalic.woff'
                '''
                .myoui * {font-family: 'Roboto', 'sans-serif';}
                '''
            ].join '\n'

        if process.browser # browser code
            reactSelect = require 'raw!./styles/react-select.css'
            css_animations = css_animations or require 'raw!./styles/animations.css'
        else # electron code
            fs = require 'fs'
            dirname =  __dirname.replace(/\\/g, '/')
            reactSelect = fs.readFileSync dirname + '/styles/react-select.css', 'utf8'
            css_animations = css_animations or fs.readFileSync dirname + '/styles/animations.css', 'utf8'

        # Adding css to the document
        add_css font_faces + base_css + reactSelect + css_animations + extra_css

module.exports = {MyoUI, mixins, theme_utils, css_utils, react_utils}
