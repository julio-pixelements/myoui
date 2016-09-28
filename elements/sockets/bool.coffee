{ React, Component, mixins, theme } = require '../../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class BoolSocket
    context: null
    constructor: (custom_theme={})->
        {context} = @
        theme = context.theme
        swch = new context.Switch custom_theme
        socket = new context.sockets.Socket custom_theme
        @ui = (props, flip)-> Component
            render: ->
                swch.ui
                    id: props.id
                    label: props.label
                    icon: socket.ui props.type
                    read: -> props.value
                    write: (currentState) -> props.value = (currentState + 1) % 2
                    flip: flip

module.exports = {BoolSocket}
