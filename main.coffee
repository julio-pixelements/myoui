{ React, ReactDOM, mixins } = require './common.coffee'

Theme = require './styles/default_theme/default_theme.coffee'

# utils
react_utils = {React, ReactDOM}
css_utils = require './styles/css_utils.coffee'

elements ={
    Button: require './elements/button.coffee'
    Switch: require './elements/switch.coffee'
    Slider: require './elements/slider.coffee'
    Vector: require './elements/vector.coffee'
    TextInput: require './elements/text_input.coffee'
    Selector: require './elements/selector.coffee'
    Splitter: require './elements/splitter.coffee'
    PopupMenuManager: require('./elements/popup_menu.coffee')
}

class MyoUI
    constructor: (@theme=new Theme)->
        myoui = @
        for name,cls of elements
            @[name] = new_cls = class myoui_component extends cls
                constructor: (props)->
                    super myoui, props
                    @type = name

        # TODO: find a better way to do this
        required_css = '''
        .myoui * {
            box-sizing: border-box;
            margin: 0;
          }
        .myoui {
            box-sizing: border-box;
            margin: 0;
          }
        '''
        # TODO: do not use reactSelect
        if process.browser # browser code
            reactSelect = require 'raw-loader!./styles/default_theme/css/react-select.css'
        else # electron code
            fs = require 'fs'
            dirname =  __dirname.replace(/\\/g, '/')
            reactSelect = fs.readFileSync dirname + '/styles/default_theme/css/react-select.css', 'utf8'
        # Adding css to the document
        if document?
            css_utils.add_css required_css + reactSelect
        else
            console.warn 'Required css files will not be used because you are executing MyoUI out of a browser.'

module.exports = {MyoUI, mixins, Theme, css_utils, react_utils}
