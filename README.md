# MyoUI

MyoUI is a __basic UI elements__ library and you can use it to make your own user interface.
MyoUI is currently used in the [Myou Editor](https://github.com/myou-engine/myou-engine).

This library was created as a part of Myou Editor, but we moved it to an independent repository
to use it on any other project.

MyoUI is based on React and you don't need to append any extra css file to your project to use it.

The basic UI theme can be easily replaced or extended with your own theme using some tools included in the library.

-----
## Usage
All the code used in the examples has been written in coffee-script.
### Install the package
```
npm install --save myoui
```

### Initializing MyoUI
```coffee-script
{MyoUI, Theme, mixins, css_utils, react_utils} = require 'myoui'

# adding default css code to the document:
require 'myoui/default_fonts'
require 'myoui/default_animations'

# Creating a myoui instance
myoui = new MyoUI new Theme
```

### Using a custom theme
```coffee-script
custom_theme = new Theme
    # In this theme spacing and colors will
    # be overwrited in the default theme
    spacing: 10 #px
    colors:
        t1: '#5a5a5a'
        light: '#eaeaea'
        dark: '#828282'
        yellow: 'FFD111'
        green: '#BCE346'
        blue: '#00BEFF'
        red: '#f16b5c'
        purple: '#c188cf'


# Creating a myoui instance
myoui = new MyoUI custom_theme
```


### Adding a custom CSS

In this example we will add a css wich contains custom fonts and animations instead of using default_fonts and default animations.

This code
```coffee-script
require 'myoui/default_animations'
require 'myoui/default_fonts'
```

will be replaced by

```coffee-script
if process.browser # browser code
    css_code = require 'raw!./css/fonts_and_animations.css'
else # electron code
    fs = require 'fs'
    dirname =  __dirname.replace(/\\/g, '/')
    css_code = fs.readFileSync dirname + '/css/fonts_and_animations.css', 'utf8'

css_utils.add_css css_code
```

Where the css file will be required depending if your app is being executed
in electron or in a browser (using webpack).

Alternatively you can simply add the css files in your html or generate the css code using the css utils included in the MyoUI package.

### Rendering a MyoUI basic element (complete example)
```coffee-script
{MyoUI, Theme, mixins, react_utils} = require 'myoui'

# adding default css code to the document:
require 'myoui/default_fonts'
require 'myoui/default_animations'

# Creating a myoui instance
myoui = new MyoUI new Theme

# Creating a button
btn = new myoui.Button

{Component, React, ReactDOM} = react_utils
{div} = React.DOM

main_component = Component
    render: ->
        div
            className: 'ButtonExample'
            style:
                backgroundColor: mixins.colors.dark
                width: '100vw'
                height: '100vh'

            btn.ui {
                label: 'Button example'
                icon: require './static_files/images/icon.png'
                onMouseUp: (event)-> alert 'Hi!'
            }

ReactDOM.render component(), document.getElementById('app')

```

### Basic elements properties
#### Button
```coffee-script
button_props =
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    onMouseUp: (event)-> alert 'Hi!'
        # this is a regular onMouseUp function

```
#### Slider
```coffee-script
variable = 10

slider_props =
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    min: -100 # absolute min
    softMin: 0 # visible min (softMin = min by default)
    softMax: 10 # visible max (softMax = max by default)
    max: 100 # absolute max

    read: ->
        # It will be called when the component will be mounted and
        # if onChange is enabled it will be called onSlideEnd
        # its prurpose is to update the slider value
        return variable

    onChange: (value) ->
        # It will be called each slide gesture frame
        # here you can write the value of the slider
        variable = value

    onSlideEnd: (value) ->
        # It will be called in the slide gesture end
        # here you can write the value of the slider
        variable = value

    step: 1
        # the slide will move jumping step by step
        # This option is disabled by default
        # To enable it you must assign any positive number

    unit: '<value> px'
        # the value will be inserted in <value> tag
        # you can use only 1 <value> tag
        # if the <value> tag is not used, the unit will be placed after the value.

    allowManualEdit: true
        # This is true by default.
        # If true, the user can click to enter a numeric value

    hideValue: false
        # If it is enabled, removes the value from the sldier.

    barColor: (f)->
        # It could be a css color (string) or
        # a function wich returns a css color (string).
        # the argument of the function is a factor (max_width_of_bar/current_size_of_bar).
        # This function is defined by default in mixins.coffee

        # Example of custom barColor function:
        v = Math.floor(255*f)
        return "rgb(#{v + 20},#{255 - v},#{200})"

    movementAccuracy: 1 # lower movementAccuracy makes slower the slide movement



```

#### Switch
```coffee-script
variable = 10

switch_props =
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    states: 3 # 2 by default
        # number of different states, the switch supports any number of
        # states but we recomend use 2 or 3. More states could be confusing.

    read: -> variable
        # It will be called on render
        # its purpose is to update the switch current state reading it
        # from a external variable.

    write: (currentState)-> variable = (currentState + 1) % 3
        # It will save the new state on a external variable.
        # It will be called on mouse up

    switchColor: (colorFactor)->
        # It could be a css color (string) or
        # a function wich returns a css color (string).
        # the argument of the function is colorFactor defined by
        # (current_state/number_of_states).
        # It is defined by default in mixins.coffee

        return mixins.colorInterpolation colors.red, colors.green, colorFactor
```

#### TextInput
```coffee-script
text_input_props =
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    read: -> text
        # It will be called on render
        # its purpose is to update the current tex value reading it
        # from a external variable.

    onSubmit: (t)-> text = t
        # It will save the new value on a external variable.
        # It will be called on submit (enter)

    onChange: (t)-> text = t
        # It will save the new value on a external variable.
        # It will be called on each keydown
```

#### Vector
```coffee-script
vector = [0,0,1]

vector_props =
    label: 'string'
        # it could be a string or null

    icon: require '../../static_files/images/icon.png'
        # it could be a URL or a component or null

    min: -100 # absolute min
    softMin: 0 # visible min (softMin = min by default)
    softMax: 10 # visible max (softMax = max by default)
    max: 100 # absolute max

    read: (i)->
        # It will be called when the component will be mounted and
        # if onChange is enabled it will be called onSlideEnd
        # its prurpose is to update the slider value
        return vector[i]

    onChange: (value, i) ->
        # It will be called each slide gesture frame
        # here you can write the value of the slider
        vector[i] = value

    onSlideEnd: (value, i) ->
        # It will be called in the slide gesture end
        # here you can write the value of the slider
        vector[i] = value

    step: 1
        # the slide will move jumping step by step
        # This option is disabled by default
        # To enable it you must assign any positive number

    unit: '$ <value> px'
        # the value will be inserted in <value> tag
        # you can use only 1 <value> tag
        # if the <value> tag is not used, the unit will be placed after the value.

    allowManualEdit: true
        # This is true by default.
        # If it is false, the value manual edition mode
        # will be disabled.

    hideValue: false
        # If it is enabled, removes the value from the sldier.

    barColor: (f)->
        # It could be a css color (string) or
        # a function wich returns a css color (string).
        # the argument of the function is a factor (max_width_of_bar/current_size_of_bar).
        # This function is defined by default in mixins.coffee

        # Example of custom barColor function:
        v = Math.floor(255*f)
        return "rgb(#{v + 20},#{255 - v},#{200})"

    vertical: false
        # vertical UI false by default.
    movementAccuracy: 1 (lower movementAccuracy makes slower the slide movement)

```

#### Splitter
```coffee-script
splitter_props =
    label: 'string'
        # it could be a string or null
```
## Documentation
It will improved soon.

## Examples
It will be added soon.

## Feedback

You can send any feedback or question to:
* Julio Manuel López <julio@pixlements.net>
