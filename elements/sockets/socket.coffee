{ React, Component, mixins, theme } = require '../../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM
class Socket
    context: null
    constructor: (custom_theme={})->
        theme = @context.theme
        @ui = (type)-> div #sockets
            className: 'socket'
            style:[
                if custom_theme.shadows?
                    mixins.boxShadow custom_theme.shadows.small
                else
                    mixins.boxShadow theme.shadows.small
                background:
                    custom_theme.socketColors?[type] or theme.socketColors[type]
                borderRadius: '100%'
                width: 15
                height: 15.5
                zIndex: 1000000
                mixins.border3d 0.3, "1px"
            ]

module.exports = {Socket}
