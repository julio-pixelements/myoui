{ React, Component, mixins, theme } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video} = React.DOM

module.exports = Component
    render: ->
        img
            className: 'myoui icon'
            src: @props.src
            style: [
                width: 40
                userSelect: 'none'
                @props.style
            ]
