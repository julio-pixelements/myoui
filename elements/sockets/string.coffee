{ React, Component, mixins, theme } = require '../../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class StringSocket
    context: null
    constructor: (custom_theme={})->
        {context} = @
        theme = context.theme
        text_input = new context.TextInput custom_theme
        socket = new context.sockets.Socket custom_theme
        @ui = (props, flip)-> Component
            render: ->
                text_input.ui
                    id: props.id
                    label: props.label
                    flip: flip
                    icon: socket.ui props.type
                    read: -> props.value
                    onSubmit: (t)-> props.value = t

module.exports = {StringSocket}
