{ React, mixins } = require '../common.coffee'
e = React.createElement

Icon = require './icon.coffee'
dimensionNames = 'xyzwvutsrqponmlkjihgfedcba'

class Vector extends React.Component
    @defaultProps:
        component_names: 'xyzw' # array or string

    theme: {}

    constructor: (@myoui, props={}) ->
        super props
        @state = mouseover: false
        theme = @theme = {@myoui.theme..., @theme..., props.theme...}

        #TODO: support vmath vectors
        vector = @props.vector
        if not (vector instanceof Array)
            throw 'Property "vector" must be an array.'
        if vector.length > @props.component_names.length
            throw "Vector length (#{vector.length}) is bigger than component_names length (#{@props.component_names.length})"

        # Each vector element is a slider.
        # This will generate a list of slider components
        @vector_props = for i in [0...vector.length] then do (i) =>
            # read/write functions could be predefined because
            # the vector property is not optional and we know what to read/write
            # read function
            if @props.read?
                read = => @props.read i
            else
                read = => @props.vector[i]
            # write functions
            definedOnChange = @props.onChange?
            definedOnSlideEnd = @props.onSlideEnd?
            if definedOnChange or definedOnSlideEnd
                if definedOnChange
                    onChange = (v) => @props.onChange v,i
                if definedOnSlideEnd
                    onSlideEnd = (v) =>  @props.onSlideEnd v,i
            else
                onChange = (v) =>
                    @props.vector[i] = v

            id = @props.component_names[i]
            # Creating slider props
            {
                label: id
                key: @props.id + '.elements.' + id
                read: read
                onChange: onChange
                onSlideEnd: onSlideEnd
                max: @props.max
                min: @props.min
                softMax: @props.softMax
                softMin: @props.softMin
                step: @props.step
                unit: @props.unit
                flip: @props.flip
                icon: @props.componentsIcons?[i]
                allowManualEdit: @props.allowManualEdit
                hideValue: @props.hideValue
                movementAccuracy: @props.movementAccuracy
                #TODO: make barColor customizable in each
                # vector element
                barColor: @props.barColor
                custom_theme:
                    input: [
                        theme.vector.element.input @props.vertical, vector.length
                        ]
                    custom_themelabel: [
                        theme.vector.element.label
                        ]
                    UIElementContainer: => [
                        theme.vector.element.container @props.vertical
                        ]
                    slider:
                        bar: => [
                            theme.vector.element.bar @props.vertical
                            ]
                        style: {
                            theme.vector.element.style...
                        }
            }

    render: ->
        theme = @theme
        label = icon = null
        if @props.label
            label = e 'div',
                key: @props.id + '.label'
                className: 'label'
                style: {
                    userSelect: 'none'
                    (theme.label theme.slider.label.maxWidth)...
                }
                @props.label

            icon = @props.icon
            #if icon is an url the component will be created here
            if typeof(icon) == 'string'
                icon = e Icon,
                    src: icon
                    key: @props.id + '.icon'
                    style: theme.icon

            headerProps =  {
                # Based on button
                key: @props.id + '.header'
                className: 'vectorHeader'
                style: {
                    # required style
                    mixins.rowFlex...
                    alignItems: 'center'
                    justifyContent: if icon and label then 'flex-start' else 'center'
                    width: '100%'
                    userSelect: 'none'
                    theme.UIElement...
                    # customizable style
                    theme.button...
                }
            }
            header = e 'div', headerProps, icon, label

        elementsContainer = e 'div',
            className: 'vectorElementsContainer'
            key: @props.id + '.elements'
            style: {
                (if @props.vertical then theme.columnFlex else mixins.rowFlex)...
                justifyContent: 'space-around'
                width: '100%'
                (theme.vector.elementsContainer @props.vertical, @props.labels)...
            }
            # Based on sliders
            for p in @vector_props
                e @myoui.Slider, p

        highlighted = (@props.useHighlight and @state.mouseover) or @props.forceHighlight
        e 'div',
            key: @props.id
            className: 'vector'
            onMouseOver: (e)=>
                if not @state.mouseover
                    @setState 'mouseover': true
            onMouseOut: (e)=>
                if @state.mouseover
                    @setState 'mouseover': false
            style: {
                # required style
                mixins.columnFlex...
                width: '100%'
                (theme.UIElementContainer @props.disabled, highlighted)...
            }
            header
            elementsContainer

module.exports = Vector
###
Example:
# vector = [0,0,1]

{
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

}
###
