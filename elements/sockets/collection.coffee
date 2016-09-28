{ React, Component, mixins, theme } = require '../../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

class CollectionSocket
    context: null
    constructor: (custom_theme={})->
        {context} = @
        theme = context.theme
        selector = new context.Selector custom_theme
        socket = new context.sockets.Socket custom_theme
        @ui = (props, flip)-> Component
            render: ->
                selector.ui
                    id: props.id
                    label: props.label
                    flip: flip
                    icon: socket.ui props.type
                    options: props.collection
                    read: props.selection
                    onChange: (selection) -> props.selection = selection

module.exports = {CollectionSocket}
