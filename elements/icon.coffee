{ React, mixins, theme } = require '../common.coffee'
e = React.createElement

module.exports = class Icon extends React.Component
    render: ->
        e 'img',
            className: 'myoui icon'
            src: @props.src
            style: {
                width: 40
                userSelect: 'none'
                @props.style...
            }
