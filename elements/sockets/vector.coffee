{ React, Component, mixins, theme } = require '../../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class VectorSocket
    context: null
    constructor: (custom_theme={})->
        {context} = @
        theme = context.theme
        vector = new context.Vector custom_theme
        slider = new context.Slider custom_theme
        btn = new context.Button
            button: mixins.columnFlex
        socket = new context.sockets.Socket custom_theme
        @ui = (props, flip)->
            props.component_names = props.component_names or 'xyzwvutsrqponmlkjihgfedcba'
            split = props.mode == 'split'
            Component
                render: ->
                    vector.ui
                        vectorElements: props.component_names
                        id: props.id
                        label: props.label
                        flip: flip
                        icon: if not split then socket.ui props.type
                        componentsIcons:
                            if split
                                for i in props.value
                                    socket.ui 'float'
                        min: props.min
                        softMin: props.softMin
                        softMax: props.softMax
                        max: props.max
                        vector: props.value
                        vertical: split
                        read: (i)-> props.value[i]
                        onChange: (value, i) -> props.value[i] = value

module.exports = {VectorSocket}
