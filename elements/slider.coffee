{ React, Component, mixins } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

icon_component = require './icon.coffee'

roundToLastMultiple = (n,m)->
    Math.floor(n/m) * m

class Slider
    constructor: (@context, custom_theme={})->
        theme = @context.theme
        @ui = Component
            getDefaultProps: ->
                useHighlight: false
                allowManualEdit: true
                movementAccuracy: 1
                custom_theme: null
                formatValue: null

            getInitialState: ->
                value: null
                sliding: false
                editing: false
                editingValue: null
                editingResult: null
                invalidInput: false
                stepOffset: 0

            componentWillUpdate: ()->
                if not (@state.editing or @state.sliding)
                    @state.value = @props.read?()

            componentWillMount: ->
                if not @props.read
                    throw 'No "read" property defined in the slider config.'
                if not @props.onChange and not @props.onSlideEnd
                    console.warn 'No "onChange" or "onSlideEnd" properties defined in the slider config. The value will not be saved.'

                if @props.step
                    value = @props.read?()
                    stepOffset = value - roundToLastMultiple(value,@props.step)
                    @setState {value, stepOffset}
                else
                    @setState {value: @props.read?()}

            render: ->
                custom_theme = @props.custom_theme or custom_theme
                # Optional max, min, softMax, softMin
                {max, min, softMax, softMin, allowBar, movementAccuracy} = @props
                max = if max? then max else Infinity
                min = if min? then min else -Infinity
                softMax = if softMax? then softMax else max
                softMin = if softMin? then softMin else min

                icon = label = value_component = null

                # movementFactor is the inverse of movementAccuracy
                movementFactor = 1 / movementAccuracy

                # hide slidebar if there are no softMax or softMin
                noSlideBar = softMax == Infinity or softMin == -Infinity

                # Reading value
                value = @state.value

                # Unit formating
                preunit = ''
                postunit = ''
                unit = @props.unit

                if unit
                    vindex = unit.indexOf '<value>'
                    if vindex > -1
                        preunit = unit[0 ... vindex]
                        postunit = unit[vindex + 7 ... unit.length]
                    else
                        postunit = unit

                if not @props.hideValue
                    # You can enter in editable mode doubleclicking in the value div
                    # to submit value you sould press "ENTER"
                    # to dimiss you sould press "ESC"

                    if @state.editing
                        value_content = @state.editingValue

                    else
                        v = value
                        if @props.step
                            v = roundToLastMultiple(value, @props.step) + @state.stepOffset
                            v = Math.min(Math.max(v, min),max)
                        if @props.formatValue
                            value_content = @props.formatValue(v)

                        else
                            floor_v = Math.floor(v)
                            if v == floor_v
                                value_content = floor_v
                            else
                                value_content = v.toFixed(2)
                            value_content = preunit + value_content + postunit

                    value_component = input
                        className: 'myoui slider_value'
                        key: @props.id + '.value'
                        value: value_content
                        title: if @state.editing then 'Press ENTER to submit or ESC to dimiss' else 'Click to edit'

                        style:[
                            theme.slider.value
                            custom_theme.value
                            if @state.invalidInput
                                theme.invalidInput
                                custom_theme.invalidInput? and custom_theme.invalidInput

                            custom_theme.input
                            # TODO: move this to mixins:
                            if not @props.allowManualEdit
                                {pointerEvents: 'none'
                                background: 'none'
                                borderWidth: 0}
                            ]

                        onChange: (event) =>
                            v = event.target.value
                            invalidInput = false
                            result = 0
                            try invalidInput = isNaN(result=eval(v))
                            catch error then invalidInput = true
                            @setState {editingResult: result, editingValue: v, invalidInput: invalidInput}

                        onFocus: (event) =>
                            @setState {editingResult: value, editingValue: value, editing: true}
                        onBlur: (event) =>
                            @setState {editing: false, invalidInput: false}

                        onKeyDown: (event)=>
                            if event.keyCode == 13 # ENTER (submit)
                                if @state.invalidInput
                                    return
                                v = eval(@state.editingValue)
                                if @props.step
                                    v = roundToLastMultiple(v,@props.step) + @state.stepOffset
                                v = Math.min(Math.max(v, min),max)
                                if @props.onSlideEnd
                                    @props.onSlideEnd v
                                else if @props.onChange
                                    @props.onChange v

                                event.target.blur()
                                @setState {value: v}

                            else if event.keyCode == 27 # ESC (dimiss)
                                @setState {editing: false, invalidInput: false}

                        # preventing event propagation to the slider.
                        onMouseDown: (event)->
                            event.stopPropagation()
                        onMouseUp: (event)->
                            event.stopPropagation()

                if @props.label
                    label = div
                        key: @props.id + '.label'
                        className: 'myoui label'
                        style: [
                            userSelect: 'none'
                            theme.label theme.slider.label.maxWidth
                            custom_theme.label? and custom_theme.label theme.slider.label.maxWidth
                            ]
                        if @props.hideValue then @props.label else @props.label + ':'

                # If icon is an url the component will be created here
                icon = @props.icon
                if typeof(icon) == 'string'
                    icon = icon_component
                        src: icon
                        key: @props.id + '.icon'
                        style:[
                            theme.icon
                            custom_theme.icon? and custom_theme.icon
                            ]

                # SLIDER EVENTS
                onSlideStart = (event)=>
                    if @state.editing
                        return
                    if @state.sliding
                        onSlideEnd(event)
                    # initializing relative mouse movement
                    sensor = event.currentTarget
                    if event.touches?.length
                        sensor.lastX = event.touches[0].clientX
                    else
                        sensor.lastX = event.clientX
                    # Changing to sliding mode
                    @setState {sliding: true}

                onSliding = (event)=>
                    if not @state.sliding or @state.editing or (not event.buttons and not event.touches?.length)
                        return
                    # lower factor -> higher accuracy
                    factor = movementFactor
                    if event.shiftKey
                        factor *= 0.1

                    if @props.flip
                        factor *= -1

                    # The first lastX value is saved in the slider onMouseDown
                    sensor = event.currentTarget
                    # Getting mouse movement relative to last position
                    if event.touches?.length
                        new_x = event.touches[0].clientX

                        event.preventDefault()
                    else
                        new_x = event.clientX
                    x = sensor.lastX - new_x
                    # Saving new position to be used in the next iteration
                    sensor.lastX = new_x

                    # Transform movement with the size of the slider to get the value addition
                    range = if noSlideBar then 100 else softMax - softMin
                    v = (x / sensor.offsetWidth) * range * (-factor)

                    # Applying the value adition and constraints.
                    v = Math.min(Math.max(value + v, softMin),softMax)

                    if @props.step
                        # Applying step
                        rounded_v = roundToLastMultiple(v,@props.step) + @state.stepOffset
                        # Applying the value adition and constraints.
                        rounded_v = Math.min(rounded_v, softMax)
                        if @props.onChange and sensor.last_rounded_v? and (rounded_v != sensor.last_rounded_v)
                            # the value will be saved only if it has been changed
                            @props.onChange(rounded_v)
                        sensor.last_rounded_v = rounded_v
                    else
                        # Saving value and setting state
                        if @props.onChange
                            @props.onChange(v)
                    @setState {value: v}

                onSlideEnd = (event)=>
                    event.preventDefault()
                    if @state.editing or not @state.sliding
                        return

                    if event.touches
                        if event.touches.length
                            return

                    if not @state.sliding
                        return
                    # write value
                    v = value
                    if @props.step
                        v = Math.min(roundToLastMultiple(v,@props.step) + @state.stepOffset, softMax)
                    @props.onSlideEnd?(v)
                    @setState {
                        # read value again
                        value: @props.read?()
                        # exit from sliding mode
                        sliding: false
                    }


                # slide sensor is a full window div which recives the sliding gesture
                # it will apear only if sliding mode is enabled.
                slide_sensor =  div
                    className: 'myoui slide_sensor'
                    onMouseLeave: onSlideEnd
                    onMouseDown: onSlideEnd
                    onDragStart: (event)->
                        event.preventDefault()
                        event.stopPropagation()

                    style:[
                        display: if @state.sliding then 'block' else 'none'
                        cursor: 'w-resize'
                        zIndex: 1
                        mixins.fullWindow
                        userSelect: 'none'
                    ]

                props = {
                    key: @props.id + 'slider'
                    className: 'myoui slider'
                    title: 'Click and slide to change the value'

                    onMouseDown: onSlideStart
                    onTouchStart: onSlideStart

                    onMouseMove: onSliding
                    onTouchMove: onSliding

                    onTouchEnd: onSlideEnd
                    onMouseUp: onSlideEnd

                    onDragStart: (event)->
                        event.preventDefault()
                        event.stopPropagation()

                    style:[
                        mixins.rowFlex
                        alignItems: 'center'
                        justifyContent: if icon and label then 'space-between' else 'center'
                        cursor: 'pointer'
                        position: 'relative'
                        theme.slider.slider
                        theme.UIElement
                        custom_theme.slider? and custom_theme.slider.slider
                        custom_theme.UIElement
                        ]
                }

                # slider bar size calc (percentage)
                if @state.editing
                    v = not isNaN(@state.editingResult) and @state.editingResult or 0
                else
                    v = value

                barColor_v = size_v = 0

                #if slidebar
                if not noSlideBar
                    factor = 1 / (softMax - softMin)
                    percent_factor = 100 * factor

                    # Condition to enable bar size transition
                    allowTransitions = (@props.step? and\
                    # step < 4% of the bar size
                    percent_factor * (@props.step - softMin) > 4)\
                    # and editing mode
                    or @state.editing

                    # getting bar color (not affected by step)
                    barColor_v = factor * (v - softMin)
                    barColor_v = Math.max(Math.min(barColor_v,1),0)
                    if typeof(@props.barColor) == 'function'
                        barColor_v = @props.barColor barColor_v
                    else
                        barColor_v = @props.barColor or theme.slider.props.barColor( barColor_v )

                    # getting bar size (affected by step)
                    if @props.step
                        v = roundToLastMultiple(v,@props.step) + @state.stepOffset
                    size_v = percent_factor * (v - softMin)
                    size_v = Math.max(Math.min(size_v,100),0)

                slideBar = div
                    key: @props.id + '.slider_bar'
                    className: 'myoui slider_bar'
                    style:[
                        position: 'absolute'
                        bottom: 0
                        if @props.flip then right: 0
                        width: "#{size_v}%"
                        pointerEvents: 'none'
                        theme.slider.bar barColor_v, allowTransitions, @props.flip
                        custom_theme.slider? and custom_theme.slider.bar barColor_v, allowTransitions, @props.flip
                        if noSlideBar
                            display: 'none'
                        ]

                if @props.flip
                    slider = div props, label, value_component, icon, slide_sensor
                else
                    slider = div props, icon, label, value_component, slide_sensor

                div
                    key: @props.id + '.slide_container'
                    className: 'myoui slider_container'
                    style:[
                        width: '100%'
                        minWidth: 100
                        minHeight: 30
                        position: 'relative'
                        theme.UIElementContainer @props.disabled, @props.useHighlight, @props.forceHighlight
                        custom_theme.UIElementContainer? @props.disabled, @props.useHighlight, @props.forceHighlight
                        ]

                    slider
                    slideBar

module.exports = {Slider}
###
Visual scheme:

[ ICON label:value=====     ]

Example:
variable = 10

{
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

    movementAccuracy: 1 (lower movementAccuracy makes slower the slide movement)

}
###
