{ React, Component, mixins, theme } = require '../../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class FloatSocket
    context: null
    constructor: (custom_theme={})->
        {context} = @
        theme = context.theme
        slider = new context.Slider custom_theme
        socket = new context.sockets.Socket custom_theme
        @ui = (props, flip)-> Component
            render: ->
                ui_props =
                    className: 'socketUI'
                    type: 'float'
                    id: props.id
                    label: props.label
                    min: props.min
                    softMin: props.softMin
                    softMax: props.softMax
                    max: props.max
                    unit: props.unit
                    flip: flip
                    icon: socket.ui props.type
                    read: -> props.value
                    onChange: (value) -> props.value = value

                if props.linked_output
                    ui_props.disabled = true
                    ui_props.allowManualEdit = false
                    ui_props.containerStyle = {opacity:1}
                    if props.linked_output.get_value?
                        ui_props.read = props.linked_output.get_value

                slider.ui ui_props

module.exports = {FloatSocket}
